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

    Write-Verbose -Message "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Stop-CmClusterNode starting on target $Cluster`:$Name."

    try
    {
        # Try to suspend the target node
        $PSBoundParameters.Add('ErrorAction', 'Stop')
        Stop-ClusterNode @PSBoundParameters
    }
    catch
    {
        Write-Warning -Message "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Failed to Stop $Cluster`:$Name."
        throw $_
    }
}
