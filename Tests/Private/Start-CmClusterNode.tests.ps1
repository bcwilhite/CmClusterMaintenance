$preReqScriptPath = Resolve-Path -Path $PSScriptRoot\..\..\Private\Get-FormattedDate.ps1
$scriptPath = Resolve-Path -Path $PSScriptRoot\..\..\Private\Start-CmClusterNode.ps1
Import-Module -Name $preReqScriptPath.Path, $scriptPath.Path -Force

Describe 'Start-CmClusterNode' {
    It 'Attempts to start a cluster node, but returns an error' {
        Mock -CommandName Start-ClusterNode -MockWith { throw 'this is a test' }
        { Start-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' } | Should throw 'this is a test'
    }

    It 'Successfully starts a cluster node and returns a cluster node object' {
        Mock -CommandName Start-ClusterNode -MockWith {
            return @{
                Cluster           = 'TestCluster'
                Name              = 'NODE1'
                State             = 'Up'
                DrainStatus       = 'NotInitiated'
                StatusInformation = 'Normal'
            }
        }
        $result = Start-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1'
        $result.Cluster           | Should -Be 'TestCluster'
        $result.Name              | Should -Be 'NODE1'
        $result.State             | Should -Be 'Up'
        $result.DrainStatus       | Should -Be 'NotInitiated'
        $result.StatusInformation | Should -Be 'Normal'
    }
}
