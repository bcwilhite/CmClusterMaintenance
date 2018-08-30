function Start-CmClusterNode
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

    Write-Verbose -Message ($script:localizedData.startingOnTarget -f $(Get-FormattedDate), 'Start-CmClusterNode', $Cluster, $Name)

    try
    {
        # Try to suspend the target node
        $PSBoundParameters.Add('ErrorAction', 'Stop')
        Start-ClusterNode @PSBoundParameters
    }
    catch
    {
        Write-Verbose -Message ($script:localizedData.failedToStart -f $(Get-FormattedDate), $Cluster, $Name)
        throw $_
    }
}
