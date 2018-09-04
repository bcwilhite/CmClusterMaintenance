$scriptPath = Resolve-Path -Path $PSScriptRoot\..\..\Private\Invoke-CmClusterMaintenance.ps1
Import-Module $scriptPath.Path

Describe 'Invoke-CmClusterMaintenance' {
    It 'Needs to have real tests' {
        $true | Should -Be $true
    }
}
