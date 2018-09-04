$scriptPath = Resolve-Path -Path $PSScriptRoot\..\..\Private\Stop-CmClusterNode.ps1
Import-Module $scriptPath.Path

Describe 'Stop-CmClusterNode' {
    It 'Needs to have real tests' {
        $true | Should -Be $true
    }
}
