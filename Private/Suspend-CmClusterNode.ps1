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

    Write-Verbose -Message ($script:localizedData.startingOnTarget -f $(Get-FormattedDate), 'Suspend-CmClusterNode', $Cluster, $Name)

    try
    {
        # Try to suspend the target node
        $PSBoundParameters.Add('Drain', $true)
        $PSBoundParameters.Add('ErrorAction', 'Stop')
        Suspend-ClusterNode @PSBoundParameters
    }
    catch
    {
        Write-Verbose -Message ($script:localizedData.failedToSuspend-f $(Get-FormattedDate), $Cluster, $Name)
        throw $_
    }
}
