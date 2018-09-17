function Get-FormattedDate
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [String]
        $Format = (Get-Culture).DateTimeFormat.UniversalSortableDateTimePattern
    )

    # Returning current time based on UniversalSortableDateTimePattern
    if (-not $PSBoundParameters.ContainsKey('Format'))
    {
        $PSBoundParameters.Add('Format', $Format)
    }
    Get-Date @PSBoundParameters
}
