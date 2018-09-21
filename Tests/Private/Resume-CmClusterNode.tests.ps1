$scriptPath = @()
$scriptPath += Resolve-Path -Path $PSScriptRoot\..\..\Private\Get-FormattedDate.ps1
$scriptPath += Resolve-Path -Path $PSScriptRoot\..\..\Private\Resume-CmClusterNode.ps1
Import-Module -Name $scriptPath.Path -Force

Describe 'Resume-CmClusterNode' {
    It 'Attempts to resume a cluster node, but returns an error' {
        Mock -CommandName Resume-ClusterNode -MockWith { throw 'this is a test' }
        { Resume-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' } | Should throw 'this is a test'
    }

    It 'Successfully resumes a cluster node and returns a cluster node object' {
        Mock -CommandName Resume-ClusterNode -MockWith {
            return @{
                Cluster           = 'TestCluster'
                Name              = 'NODE1'
                State             = 'Up'
                DrainStatus       = 'NotInitiated'
                StatusInformation = 'Normal'
            }
        }
        $result = Resume-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1'
        $result.Cluster           | Should -Be 'TestCluster'
        $result.Name              | Should -Be 'NODE1'
        $result.State             | Should -Be 'Up'
        $result.DrainStatus       | Should -Be 'NotInitiated'
        $result.StatusInformation | Should -Be 'Normal'
    }
}
