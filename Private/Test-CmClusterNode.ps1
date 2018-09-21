function Test-CmClusterNode
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $Cluster,

        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Resume', 'Start', 'Stop', 'Suspend')]
        [String]
        $TestType,

        [Parameter(Mandatory = $false)]
        [Int32]
        $TimeOut = 600
    )

    Write-Verbose -Message ($script:localizedData.startingTestType -f $(Get-FormattedDate), $Cluster.ToUpper(), $Name.ToUpper(), $TestType)

    # Removing timeout & TestType / Adding ErrorAction for Get-ClusterNode
    $PSBoundParameters.Remove('TestType') | Out-Null
    $PSBoundParameters.Remove('TimeOut')  | Out-Null
    $PSBoundParameters.ErrorAction = 'Stop'

    # Setting stopwatch to capture elapsed time so that we can break out of the while based on the TimeOut value
    $stopWatch = [System.Diagnostics.Stopwatch]::StartNew()

    # Setting nodePausedComplete to false
    $testResults = $false

    # Looping until $TimeOut expires or testResults equals $true; :breakOut is a label for the while statement, used with the break statement
    :breakOut while ($testResults -ne $true)
    {
        if ($stopWatch.Elapsed.TotalSeconds -ge $TimeOut) {
            $timerExpired = $true
            break breakOut
        }
        # try to query the node drain status from the clustered node
        try
        {
            $nodeStatus = Get-ClusterNode @PSBoundParameters
        }
        catch
        {
            Write-Verbose -Message ($script:localizedData.failedToQuery -f $(Get-FormattedDate), $Cluster.ToUpper(), $Name.ToUpper())
            throw $_
        }

        # Switching on TestType and returning $testResults
        switch ($TestType)
        {
            'Resume'
            {
                if ($nodeStatus.State -eq 'Up')
                {
                    # setting testResults to true and breaking out of the while
                    $testResults = $true
                    break breakOut
                }
            }

            'Start'
            {
                if ($nodeStatus.State -eq 'Paused')
                {
                    # setting testResults to true and breaking out of the while
                    $testResults = $true
                    break breakOut
                }
            }

            'Stop'
            {
                # if the node State is 'Down' setting $testResults and breaking out of the while
                if ($nodeStatus.State -eq 'Down')
                {
                    # setting testResults to true and breaking out of the while
                    $testResults = $true
                    break breakOut
                }
            }

            'Suspend'
            {
                # if the node State is 'Paused' using switch to determine DrainStatus and setting testResults bool
                if ($nodeStatus.State -eq 'Paused')
                {
                    # CLUSTER_NODE_DRAIN_STATUS (MSDN) - https://msdn.microsoft.com/en-us/library/dn622912(v=vs.85).aspx
                    switch ($nodeStatus.DrainStatus)
                    {
                        'NotInitiated'
                        {
                            # setting nodePausedCompeted to false and breaking out of the switch
                            $testResults = $false
                            break
                        }

                        'InProgress'
                        {
                            # setting nodePausedCompeted to false and breaking out of the switch
                            $testResults = $false
                            break
                        }

                        'Completed'
                        {
                            # setting nodePausedCompeted to true and breaking out of the while
                            $testResults = $true
                            break breakOut
                        }

                        'Failed'
                        {
                            # setting nodePausedCompeted to false and breaking out of the while
                            $testResults = $false
                            break breakOut
                        }

                        Default
                        {
                            # if the above four conditions do not apply; setting nodePausedCompeted to false
                            $testResults = $false
                        }
                    }
                }
            }
        }
        # sleeping to limit the queries for node status
        Start-Sleep -Milliseconds 750
    }

    # return true/false to the calling function
    Write-Verbose -Message ($script:localizedData.currentNodeState -f $(Get-FormattedDate), $Cluster.ToUpper(), $Name.ToUpper(), $($nodeStatus.State), $($nodeStatus.DrainStatus))
    if ($timerExpired)
    {
        Write-Verbose -Message ($script:localizedData.timerExpired -f $(Get-FormattedDate), $TimeOut, $Cluster.ToUpper(), $Name.ToUpper())
    }
    return $testResults
}
