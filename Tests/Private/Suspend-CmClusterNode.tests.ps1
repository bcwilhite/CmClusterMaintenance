$scriptPath = @()
$scriptPath += Resolve-Path -Path $PSScriptRoot\..\..\Private\Get-FormattedDate.ps1
$scriptPath += Resolve-Path -Path $PSScriptRoot\..\..\Private\Suspend-CmClusterNode.ps1
Import-Module -Name $scriptPath.Path -Force

Describe 'Suspend-CmClusterNode' {
    It 'Attempts to suspend a cluster node, but fails with terminating error' {
        Mock -CommandName Suspend-ClusterNode -MockWith { throw 'this is a test' }
        { Suspend-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' } | Should throw 'this is a test'
    }

    It 'Successfully suspends a cluster node and returns a cluster node object' {
        Mock -CommandName Suspend-ClusterNode -MockWith {
            return @{
                Cluster           = 'TestCluster'
                Name              = 'NODE1'
                State             = 'Up'
                DrainStatus       = 'NotInitiated'
                StatusInformation = 'Normal'
            }
        }
        $result = Suspend-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1'
        $result.Cluster           | Should -Be 'TestCluster'
        $result.Name              | Should -Be 'NODE1'
        $result.State             | Should -Be 'Up'
        $result.DrainStatus       | Should -Be 'NotInitiated'
        $result.StatusInformation | Should -Be 'Normal'
    }
}
