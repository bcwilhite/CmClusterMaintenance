$scriptPath = @()
$scriptPath += Resolve-Path -Path $PSScriptRoot\..\..\Private\Get-FormattedDate.ps1
$scriptPath += Resolve-Path -Path $PSScriptRoot\..\..\Private\Test-CmClusterNode.ps1
Import-Module -Name $scriptPath.Path -Force

Describe 'Test-CmClusterNode' {
    Context 'Resume tests with up and down node states' {
        It 'Uses the Resume test type to ensure the node is up, when the node is up, should return $true' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Up'
                    DrainStatus       = 'NotInitiated'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Resume' -TimeOut 1
            $result | Should -Be $true
        }

        It 'Uses the Resume test type to ensure the node is up, hits TimeOut due to the node being "down", should return $false' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Down'
                    DrainStatus       = 'NotInitiated'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Resume' -TimeOut 1
            $result | Should -Be $false
        }
    }

    Context 'Start tests with paused and down node states' {
        It 'Uses the Start test type to ensure the node is paused, when the node is paused, should return $true' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Paused'
                    DrainStatus       = 'NotInitiated'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Start' -TimeOut 1
            $result | Should -Be $true
        }

        It 'Uses the Start test type to ensure the node is paused, hits TimeOut due to the node being "down", should return $false' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Down'
                    DrainStatus       = 'NotInitiated'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Start' -TimeOut 1
            $result | Should -Be $false
        }
    }

    Context 'Stop tests with down and up node states' {
        It 'Uses the Stop test type to ensure the node is down, when the node is down, should return $true' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Down'
                    DrainStatus       = 'NotInitiated'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Stop' -TimeOut 1
            $result | Should -Be $true
        }

        It 'Uses the Stop test type to ensure the node is down, hits TimeOut due to the node being "up", should return $false' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Up'
                    DrainStatus       = 'NotInitiated'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Stop' -TimeOut 1
            $result | Should -Be $false
        }
    }

    Context 'Suspend tests with paused and down node states and various DrainStatus states' {
        It 'Uses the Suspend test type to ensure the node is paused/completed, when the node is paused/completed, should return $true' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Paused'
                    DrainStatus       = 'Completed'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Suspend' -TimeOut 1
            $result | Should -Be $true
        }

        It 'Uses the Suspend test type to ensure the node is paused/completed, hits TimeOut due to node paused/notinitiated, should return $false' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Paused'
                    DrainStatus       = 'NotInitiated'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Suspend' -TimeOut 1
            $result | Should -Be $false
        }

        It 'Uses the Suspend test type to ensure the node is paused/completed, hits TimeOut due to node paused/inprogress, should return $false' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Paused'
                    DrainStatus       = 'InProgress'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Suspend' -TimeOut 1
            $result | Should -Be $false
        }

        It 'Uses the Suspend test type to ensure the node is paused/completed, when the node is paused/failed, should return $false' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Paused'
                    DrainStatus       = 'Failed'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Suspend' -TimeOut 1
            $result | Should -Be $false
        }

        It 'Uses the Suspend test type to ensure the node is paused/completed, hits TimeOut due to node paused/UNDETERMINED (bogus state), should return $false' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Paused'
                    DrainStatus       = 'UNDERTERMINED'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Suspend' -TimeOut 1
            $result | Should -Be $false
        }

        It 'Uses the Suspend test type to ensure the node is paused/completed, when the node is down, should return $false' {
            Mock -CommandName Get-ClusterNode -MockWith {
                return @{
                    Cluster           = 'TestCluster'
                    Name              = 'NODE1'
                    State             = 'Down'
                    DrainStatus       = 'NotInitiated'
                    StatusInformation = 'Normal'
                }
            }
            $result = Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Suspend' -TimeOut 1
            $result | Should -Be $false
        }
    }

    Context 'Regardless of test type, checking Get-ClusterNode failure try/catch' {
        It 'Attempts to query cluster node state using Get-ClusterNode, but fails with terminating error' {
            Mock -CommandName Get-ClusterNode -MockWith { throw 'this is a test' } -Verbose
            { Test-CmClusterNode -Cluster 'TestCluster' -Name 'NODE1' -TestType 'Suspend' -TimeOut 1 } | Should throw 'this is a test'
        }
    }
}
