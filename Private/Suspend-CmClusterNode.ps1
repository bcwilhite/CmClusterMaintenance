function Suspend-CmClusterNode
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $Cluster,

        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $false)]
        [Switch]
        $ForceDrain
    )

    Write-Verbose -Message ($script:localizedData.startingOnTarget -f $(Get-FormattedDate), 'Suspend-CmClusterNode', $Cluster.ToUpper(), $Name.ToUpper())

    try
    {
        # Try to suspend the target node
        $clusterNodeParams = $PSBoundParameters
        $clusterNodeParams.Drain = $true
        $clusterNodeParams.ErrorAction = 'Stop'
        $clusterNodeParams.Verbose = $false
        Suspend-ClusterNode @clusterNodeParams
    }
    catch
    {
        Write-Verbose -Message ($script:localizedData.failedToSuspend-f $(Get-FormattedDate), $Cluster.ToUpper(), $Name.ToUpper())
        throw $_
    }
}
