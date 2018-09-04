$scriptPath = Resolve-Path -Path $PSScriptRoot\..\..\Private\Test-CmClusterNode.ps1
Import-Module $scriptPath.Path

Describe 'Test-CmClusterNode' {
    It 'Needs to have real tests' {
        $true | Should -Be $true
    }
}
