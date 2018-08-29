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

    Write-Verbose -Message "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Start-CmClusterNode starting on target $Cluster`:$Name."

    try
    {
        # Try to suspend the target node
        $PSBoundParameters.Add('ErrorAction', 'Stop')
        Start-ClusterNode @PSBoundParameters
    }
    catch
    {
        Write-Warning -Message "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Failed to Start $Cluster`:$Name."
        throw $_
    }
}
