$scriptPath = Resolve-Path -Path $PSScriptRoot\..\..\Private\Get-FormattedDate.ps1
Import-Module $scriptPath.Path

Describe 'Get-FormattedDate' {
    It 'Needs to have real tests' {
        $true | Should -Be $true
    }
}
