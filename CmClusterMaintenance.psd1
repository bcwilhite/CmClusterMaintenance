@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'CmClusterMaintenance.psm1'

    # Version number of this module.
    ModuleVersion = '0.4.7'

    # ID used to uniquely identify this module
    GUID = '0edaa30e-a4ab-4a8d-a3ce-528f1f5356d0'

    # Author of this module
    Author = 'Brian Wilhite'

    # Copyright statement for this module
    Copyright = '(c) 2018 Brian Wilhite. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Module used to automate Windows Failover Cluster Maintenance'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @('FailoverClusters')

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = '*'

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('CmClusterMaintenance')

            ExternalModuleDependencies = @('FailoverClusters')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/bcwilhite/CmClusterMaintenance/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/bcwilhite/CmClusterMaintenance'
        } # End of PSData hashtable
    }
}
