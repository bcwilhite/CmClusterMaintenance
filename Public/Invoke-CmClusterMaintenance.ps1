<#
    .SYNOPSIS
    Invoke-CmClusterMaintenance is used to start node maintenance on all nodes in a cluster, coordinating node drain and reboot (optional).

    .DESCRIPTION
    Invoke-CmClusterMaintenance is used to start node maintenance on all nodes in a cluster, coordinating node drain and reboot (optional).
    The function will query all cluster nodes using Get-ClusterNode with the given cluster name.  Once it receives the cluster nodes it will loop through all nodes within the cluster, pausing, stopping, performing an action (specified via the Scriptblock parameter), rebooting (if specified via the Reboot switch parameter), starting, resuming and detecting success in each step of the coordinated process.  If any one of the steps is not successful, the entire coordinated process will fail, if the Verbose parameter is used, more detial around possible causes for the failure can be used for troubleshooting purposes.

    .PARAMETER Cluster
    Specifies the name of the cluster on which to run this function.  The function will loop through all nodes of the specified cluster invoking the action contained within the scriptblock parameter.

    .PARAMETER ForceDrain
    Specifies that workloads are moved from a node even in the case of an error.

    .PARAMETER ScriptBlock
    Specifies the commands to run. Enclose the commands in braces ( { } ) to create a script block. This parameter is required.

    By default, any variables in the command are evaluated on the remote computer.

    .PARAMETER ArgumentList
    Supplies the values of local variables in the command. The variables in the command are replaced by these values before the command is run on the remote computer. Enter the values in a comma-separated list. Values are associated with variables in the order that they are listed. The alias for ArgumentList is "Args".

    The values in ArgumentList can be actual values, such as "1024", or they can be references to local variables, such as "$max".

    To use local variables in a command, use the following command format:

    {param($<name1>[, $<name2>]...) <command-with-local-variables>} -ArgumentList <value> -or- <local-variable>

    or

    $localVariable = 'Data is stored here'
    Invoke-CmClusterMaintenance -Cluster HV-CLUS1 -ScriptBlock {$using:localVariable} -ArgumentList $localVariable -RebootNode

    The "param" keyword lists the local variables that are used in the command. The ArgumentList parameter supplies
    the values of the variables, in the order that they are listed.

    .PARAMETER TimeOut
    Specifies the number of seconds in which the function will wait for the drain action to complete for a node.  If the TimeOut expires, then the function will fail for the cluster.

    *** In it's current state, if a drain fails, then the function will stop and take no further action for the entire cluster if you wish to modify this behavior, it is possible, but will require additional logic/modification. ***

    .PARAMETER RebootNode
    Specifying the RebootNode switch parameter will cause the node to reboot after the scriptblock contents is executed against the node.

    .EXAMPLE
    $scriptBlock = {"Action to perform on $env:ComputerName"}
    Invoke-CmClusterMaintenance -Cluster HV-CLUS1 -ScriptBlock $scriptBlock -RebootNode

    This example will execute the contents of the scriptblock then reboot the node, one at a time, for all nodes in the HV-CLUS1 cluster.

    .NOTES
    Created by Brian Wilhite
#>
function Invoke-CmClusterMaintenance
{
    [CmdletBinding(DefaultParameterSetName = 'ScriptBlock')]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $Cluster,

        [Parameter()]
        [Switch]
        $ForceDrain,

        [Parameter(Mandatory = $true, ParameterSetName = 'ScriptBlock')]
        [ScriptBlock]
        $ScriptBlock,

        [Parameter(Mandatory = $true, ParameterSetName = 'FilePath')]
        [ValidateScript({Test-Path -Path $_})]
        [String]
        $FilePath,

        [Parameter()]
        [System.Object[]]
        $ArgumentList,

        [Parameter()]
        [Int32]
        $TimeOut = 600,

        [Parameter()]
        [Switch]
        $RebootNode
    )

    Write-Verbose -Message "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Invoke-CmClusterMaintenance starting on target $Cluster."

    # Get Cluster Nodes
    try
    {
        $clusterNodes = Get-ClusterNode -Cluster $Cluster -ErrorAction Stop
    }
    catch
    {
        throw $_
    }

    # Removing RebootNode, Scriptblock, FilePath & TimeOut from PSBoundParams
    $PSBoundParameters.Remove('RebootNode')   | Out-Null
    $PSBoundParameters.Remove('ScriptBlock')  | Out-Null
    $PSBoundParameters.Remove('FilePath')     | Out-Null
    $PSBoundParameters.Remove('ArgumentList') | Out-Null
    $PSBoundParameters.Remove('TimeOut')      | Out-Null

    # If the ForceDrain parameter was specified remove it from PSBoundParams and add ForceDrain = $true to the hashtable for splatting
    if ($PSBoundParameters.Remove('ForceDrain'))
    {
        [hashtable]$suspendCmClusterNodeParams = $PSBoundParameters
        $suspendCmClusterNodeParams.ForceDrain = $true
    }
    else
    {
        $suspendCmClusterNodeParams = $PSBoundParameters
    }

    # Loop, using for to track cluster progress
    for ($i = 0; $i -lt $clusterNodes.Count; $i++)
    {
        # Setting up the Write-Progress parameter - Splatting
        $writeProgressPrcent = [Math]::Round($i / $clusterNodes.Count * 100)
        $writeProgressParams = @{
            Activity        = "Performing maintenance on Cluster: $($Cluster.ToUpper()); Node: $($clusterNodes[$i].Name)"
            Status          = "Node $($i + 1) of $($clusterNodes.Count) currently processing..., Percent Complete: $writeProgressPrcent`%"
            PercentComplete = $writeProgressPrcent
            Id              = 1
        }
        Write-Progress @writeProgressParams

        # Adding the current cluster node to PSBoundParameters/SuspendCmClusterNodeParams
        $PSBoundParameters.Name          = $clusterNodes[$i].Name
        $suspendCmClusterNodeParams.Name = $clusterNodes[$i].Name

        try
        {
            # Suspending current cluster node
            Write-Progress -Activity "Performing Suspend-CmClusterNode on $($clusterNodes[$i].Name)" -ParentId 1 -PercentComplete (1/8 * 100)
            Suspend-CmClusterNode @suspendCmClusterNodeParams | Out-Null

            # Testing successful cluster node SUSPEND operation
            Write-Progress -Activity "Performing Test-CmClusterNode TestType Suspend on $($clusterNodes[$i].Name)" -ParentId 1 -PercentComplete (2/8 * 100)
            if (Test-CmClusterNode @PSBoundParameters -TestType Suspend -TimeOut $TimeOut)
            {
                # If cluster node suspend was successful, stop the cluster node
                Write-Progress -Activity "Performing Stop-CmClusterNode on $($clusterNodes[$i].Name)" -ParentId 1 -PercentComplete (3/8 * 100)
                Stop-CmClusterNode @PSBoundParameters | Out-Null
            }
            else
            {
                # Otherwise throw an time stamped error
                throw "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Suspend-CmClusterNode failed for $Cluster`:$($PSBoundParameters.Name)."
            }

            # Testing successful cluster node STOP operation
            Write-Progress -Activity "Performing Test-CmClusterNode TestType Stop on $($clusterNodes[$i].Name)" -ParentId 1 -PercentComplete (4/8 * 100)
            if (Test-CmClusterNode @PSBoundParameters -TestType Stop -TimeOut $TimeOut)
            {
                # Setting up Invoke-Command parameters
                Write-Progress -Activity "Performing Invoke-Command on $($clusterNodes[$i].Name)" -ParentId 1 -PercentComplete (5/8 * 100)
                $invokeCmdParams = @{
                    ComputerName = $clusterNodes[$i].Name
                    ErrorAction  = 'Stop'
                }

                # If the ScriptBlock param was specified, then add it to the invokeCmdParams hashtable for splatting
                if ($ScriptBlock)
                {
                    $invokeCmdParams.ScriptBlock = $ScriptBlock
                }

                # If the FilePath param was specified, then add it to the invokeCmdParams hashtable for splatting
                if ($FilePath)
                {
                    $invokeCmdParams.FilePath = $FilePath
                }

                # If the ArgumentList param was specified, then add it to the invokeCmdParams hashtable for splatting
                if ($ArgumentList)
                {
                    $invokeCmdParams.ArgumentList = $ArgumentList
                }

                # Invoking the specified scriptblock and parameters on the current cluster node
                Invoke-Command @invokeCmdParams

                # If the RebootNode param was specified, then Restart-Computer on the current cluster node and wait for PowerShell remoting on the target node before continuing
                if ($RebootNode)
                {
                    Write-Verbose -Message "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Restart-Computer starting on target $Cluster`:$Name."
                    Restart-Computer -ComputerName $PSBoundParameters.Name -Wait -For PowerShell -Force
                }
            }
            else
            {
                throw "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Stop-CmClusterNode failed for $Cluster`:$($PSBoundParameters.Name)."
            }

            # Start the cluster service on the current cluster node
            Write-Progress -Activity "Performing Start-CmClusterNode on $($clusterNodes[$i].Name)" -ParentId 1 -PercentComplete (6/8 * 100)
            Start-CmClusterNode @PSBoundParameters | Out-Null

            # Testing successful cluster service START operation
            if (Test-CmClusterNode @PSBoundParameters -TestType Start -TimeOut $TimeOut)
            {
                # if cluster node START operation was successful, then attempt to resume the cluster node (Unpause)
                Write-Progress -Activity "Performing Resume-CmClusterNode on $($clusterNodes[$i].Name)" -ParentId 1 -PercentComplete (7/8 * 100)
                Resume-CmClusterNode @PSBoundParameters | Out-Null
            }
            else
            {
                throw "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Start-CmClusterNode failed for $Cluster`:$($PSBoundParameters.Name)."
            }

            # Testing successful cluster RESUME operation
            Write-Progress -Activity "Performing Test-CmClusterNode TypeType Resume on $($clusterNodes[$i].Name)" -ParentId 1 -PercentComplete (8/8 * 100)
            if (Test-CmClusterNode @PSBoundParameters -TestType Resume -TimeOut $TimeOut)
            {
                Write-Verbose -Message "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Invoke-CmClusterMaintenance on $Cluster`:$($PSBoundParameters.Name) Completed."
            }
            else
            {
                throw "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Resume-CmClusterNode failed for $Cluster`:$($PSBoundParameters.Name)."
            }
        }
        catch
        {
            Write-Warning -Message "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Operation failed for $Cluster`:$($PSBoundParameters.Name), exiting cluster maintenance."
            throw $_
        }
    }
}
