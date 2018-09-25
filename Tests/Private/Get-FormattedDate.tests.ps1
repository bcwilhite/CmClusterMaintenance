$scriptPath = Resolve-Path -Path $PSScriptRoot\..\..\Private\Get-FormattedDate.ps1
Import-Module $scriptPath.Path -Force

Describe 'Get-FormattedDate' {
    It 'Returns a universal date string' {
        $format = (Get-Culture).DateTimeFormat.UniversalSortableDateTimePattern
        Get-FormattedDate | Should -Be (Get-Date -Format $format)
    }
}
