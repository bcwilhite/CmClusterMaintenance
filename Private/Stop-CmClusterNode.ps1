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

    Write-Verbose -Message ($script:localizedData.startingOnTarget -f $(Get-FormattedDate), 'Stop-CmClusterNode', $Cluster, $Name)

    try
    {
        # Try to suspend the target node
        $PSBoundParameters.Add('ErrorAction', 'Stop')
        Stop-ClusterNode @PSBoundParameters
    }
    catch
    {
        Write-Verbose -Message ($script:localizedData.failedToStop-f $(Get-FormattedDate), $Cluster, $Name)
        throw $_
    }
}
