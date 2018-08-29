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

    Write-Verbose -Message "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Suspend-CmClusterNode starting on target $Cluster`:$Name."

    try
    {
        # Try to suspend the target node
        $PSBoundParameters.Add('Drain', $true)
        $PSBoundParameters.Add('ErrorAction', 'Stop')
        Suspend-ClusterNode @PSBoundParameters
    }
    catch
    {
        Write-Warning -Message "[$(Get-Date -Format 'yyyy/MM/dd hh:mm:ss')]: Failed to Suspend $Cluster`:$Name."
        throw $_
    }
}
