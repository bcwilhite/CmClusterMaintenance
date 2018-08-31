function Stop-CmClusterNode
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $Cluster,

        [Parameter(Mandatory = $true)]
        [String]
        $Name
    )

    Write-Verbose -Message ($script:localizedData.startingOnTarget -f $(Get-FormattedDate), 'Stop-CmClusterNode', $Cluster.ToUpper(), $Name.ToUpper())

    try
    {
        # Try to suspend the target node
        $clusterNodeParams = $PSBoundParameters
        $clusterNodeParams.ErrorAction = 'Stop'
        $clusterNodeParams.Verbose = $false
        Stop-ClusterNode @clusterNodeParams
    }
    catch
    {
        Write-Verbose -Message ($script:localizedData.failedToStop-f $(Get-FormattedDate), $Cluster.ToUpper(), $Name.ToUpper())
        throw $_
    }
}
