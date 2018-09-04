$scriptPath = Resolve-Path -Path $PSScriptRoot\..\..\Private\Start-CmClusterNode.ps1
Import-Module $scriptPath.Path

Describe 'Start-CmClusterNode' {
    It 'Needs to have real tests' {
        $true | Should -Be $true
    }
}
