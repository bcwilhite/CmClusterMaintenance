$scriptPath = Resolve-Path -Path $PSScriptRoot\..\..\Private\Resume-CmClusterNode.ps1
Import-Module $scriptPath.Path

Describe 'Resume-CmClusterNode' {
    It 'Needs to have real tests' {
        $true | Should -Be $true
    }
}
