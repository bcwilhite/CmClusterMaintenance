function Resume-CmClusterNode
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

    Write-Verbose -Message ($script:localizedData.startingOnTarget -f $(Get-FormattedDate), 'Resume-CmClusterNode', $Cluster, $Name)

    try
    {
        # Try to suspend the target node
        $PSBoundParameters.Add('ErrorAction', 'Stop')
        Resume-ClusterNode @PSBoundParameters
    }
    catch
    {
        Write-Verbose -Message ($script:localizedData.failedToResume -f $(Get-FormattedDate), $Cluster, $Name)
        throw $_
    }
}
