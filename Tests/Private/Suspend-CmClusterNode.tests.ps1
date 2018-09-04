$scriptPath = Resolve-Path -Path $PSScriptRoot\..\..\Private\Suspend-CmClusterNode.ps1
Import-Module $scriptPath.Path

Describe 'Suspend-CmClusterNode' {
    It 'Needs to have real tests' {
        $true | Should -Be $true
    }
}
