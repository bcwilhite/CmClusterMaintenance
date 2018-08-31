ConvertFrom-StringData @'
    startingOnCluster  = [{0}]: '{1}' starting on Cluster "{2}".
    startingOnTarget   = [{0}]: '{1}' starting on Cluster "{2}" Target {3}.
    startingTestType   = [{0}]: 'Test-CmClusterNode' starting on Cluster "{1}" Target "{2}", test type {3}.
    failedToResume     = [{0}]: Failed to Resume Cluster "{1}" Target "{2}".
    failedToStart      = [{0}]: Failed to Start Cluster "{1}" Target "{2}".
    failedToStop       = [{0}]: Failed to Stop Cluster "{1}" Target "{2}".
    failedToSuspend    = [{0}]: Failed to Suspend Cluster "{1}" Target "{2}".
    failedToQuery      = [{0}]: Failed to query Node Status information from Cluster "{1}" Target "{2}", Cluster Maintenance has been aborted.
    failedfunction     = [{0}]: '{1}' failed for Cluster "{2}" Target {3}.
    currentNodeState   = [{0}]: Current Node Status - Cluster "{1}" Target "{2}" {3} {4}.
    progActvFirstMsg   = Performing maintenance on Cluster "{0}" Target "{1}"
    progStatusMsg      = Node {0} of {1} currently processing... Percent Complete: {2}%
    progActvSecondMsg  = Performing 'Suspend-CmClusterNode' on {0}
    progActvThirdMsg   = Performing 'Test-CmClusterNode' TestType Suspend on {0}
    progActvFourthMsg  = Performing 'Stop-CmClusterNode' on {0}
    progActvFifthMsg   = Performing 'Test-CmClusterNode' TestType Stop on {0}
    progActvSixthMsg   = Performing 'Invoke-Command' on {0}
    progActvSeventhMsg = Performing 'Start-CmClusterNode' on {0}
    progActvEightMsg   = Performing 'Resume-CmClusterNode' on {0}
    progActvNinthMsg   = Performing 'Test-CmClusterNode' TypeType Resume on {0}
    invokeCmComplete   = [{0}]: 'Invoke-CmClusterMaintenance' on Cluster "{1}" Target "{2}" Completed.
    invokeCmFailed     = [{0}]: Operation failed for Cluster "{1}" Target "{2}", exiting Cluster Maintenance.
'@
