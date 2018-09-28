# CmClusterMaintenance

[![Build status](https://ci.appveyor.com/api/projects/status/td2dmi2hydmo5k20/branch/master?svg=true)](https://ci.appveyor.com/project/bcwilhite/cmclustermaintenance/branch/master)

Module used to automate Windows Failover Cluster Maintenance

## How to use

Deploy the CmClusterMaintenance folder from the Release folder to your PSModulePath, i.e. CmClusterMaintenance and PowerShell will automatically find/load the module.
This module is also published on the [PowerShell Gallery](https://www.powershellgallery.com/packages/cmclustermaintenance), therefore installing it via PowerShell is also an option:

```PowerShell
Install-Module -Name CmClusterMaintenance
```

This module/function will Suspend, Stop, Start and Resume a single node with verification for each phase, perform an action which is defined by the specified scriptblock.  The scriptblock invocation and optional reboot occurs between the Stop and Start Cluster node phase.

**NOTE:** If a node drain fails, then the function will stop and take no further action for the entire cluster.  Further cleanup from the failure will be required.

## Functions

* **Invoke-CmClusterMaintenance** Starts maintenance for each node in a cluster, coordinating node drain and reboot (optional).

### Invoke-CmClusterMaintenance

* **Cluster**: Specifies the name of the cluster on which to run this function.  The function will loop through all nodes of the specified cluster invoking the action contained within the scriptblock parameter.
* **ForceDrain**: Specifies that workloads are moved from a node even in the case of an error.
* **ScriptBlock**: Specifies the commands to run. Enclose the commands in braces ( { } ) to create a script block. This parameter is required.  By default, any variables in the command are evaluated on the remote computer.
* **ArgumentList**:
    Supplies the values of local variables in the command. The variables in the command are replaced by these values before the command is run on the remote computer. Enter the values in a comma-separated list. Values are associated with variables in the order that they are listed. The alias for ArgumentList is "Args".  The values in ArgumentList can be actual values, such as "1024", or they can be references to local variables, such as "$max".  To use local variables in a command, use the following command format:

```PowerShell
    {param($<name1>[, $<name2>]...) <command-with-local-variables>} -ArgumentList <value> -or- <local-variable>
    # The "param" keyword lists the local variables that are used in the command.
    # The ArgumentList parameter supplies the values of the variables, in the order that they are listed.

    or

    $localVariable = 'Data is stored here'
    $scriptBlock   = {$using:localVariable}
    Invoke-CmClusterMaintenance -Cluster <ClusterName> -ScriptBlock $scriptBlock -ArgumentList $localVariable
```

* **TimeOut**: Specifies the number of seconds in which the function will wait for the drain action to complete for a node.  If the TimeOut expires, then the function will fail for the cluster.
* **RebootNode**: Specifying the RebootNode switch parameter will cause the node to reboot after the scriptblock contents is executed against the node.

## Versions

### 0.4.7

* Initial Release

## Examples

### Execute the defined scriptblock and reboot the node, one at a time, for all nodes in the HV-CLUS1 cluster

```PowerShell
$scriptBlock = {"Action to perform on each node"}
Invoke-CmClusterMaintenance -Cluster HV-CLUS1 -ScriptBlock $scriptBlock -RebootNode
```

### Execute the nodeMaint.ps1 script and reboot the node, one at a time, for all nodes in the HV-CLUS1 cluster

```PowerShell
Invoke-CmClusterMaintenance -Cluster HV-CLUS1 -FilePath C:\Scripts\nodeMaint.ps1 -RebootNode
```
