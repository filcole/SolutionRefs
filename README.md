# SolutionRefs

Attempt to reduce noisy diffs in MissingDependencies section of solution.xml

** If you use this tool do not report issues to Microsoft Support about failing solution imports! **

## Usage

`SolutionRefs.ps1 -solnfolder ./MySolution`

  Will convert this:

```xml
<?xml version="1.0" encoding="utf-8"?>
<ImportExportXml version="9.2.22072.182" SolutionPackageVersion="9.2" languagecode="1033" generatedBy="CrmLive" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <SolutionManifest>
    <UniqueName>MissingDepsExample</UniqueName>
    <LocalizedNames>
      <LocalizedName description="Missing Deps Example" languagecode="1033" />
    </LocalizedNames>
    <Descriptions />
    <Version>1.0.0.0</Version>
    <Managed>2</Managed>
    <Publisher>  ... snip ... </Publisher>
    <RootComponents>
      <RootComponent type="1" schemaName="account" behavior="2" />
      <RootComponent type="1" schemaName="msdyn_customcontrolextendedsettings" behavior="2" />
      <RootComponent type="1" schemaName="msdyn_slakpi" behavior="2" />
    </RootComponents>
    <MissingDependencies>
      <MissingDependency>
        <Required type="1" schemaName="msdyn_customcontrolextendedsettings" displayName="Custom Control Extended Setting" solution="msdyn_UserExperiencesExtendedSettings (1.0.0.317)" />
        <Dependent type="1" schemaName="msdyn_customcontrolextendedsettings" displayName="Custom Control Extended Setting" />
      </MissingDependency>
      <MissingDependency>
        <Required type="1" schemaName="msdyn_customcontrolextendedsettings" displayName="Custom Control Extended Setting" solution="msdyn_UserExperiencesExtendedSettings (1.0.0.317)" />
        <Dependent type="2" schemaName="ownerid" displayName="Owner" parentSchemaName="msdyn_customcontrolextendedsettings" parentDisplayName="Custom Control Extended Setting" />
      </MissingDependency>
      <MissingDependency>
        <Required type="1" schemaName="msdyn_customcontrolextendedsettings" displayName="Custom Control Extended Setting" solution="msdyn_UserExperiencesExtendedSettings (1.0.0.317)" />
        <Dependent type="2" schemaName="owningbusinessunit" displayName="Owning Business Unit" parentSchemaName="msdyn_customcontrolextendedsettings" parentDisplayName="Custom Control Extended Setting" />
      </MissingDependency>
      <MissingDependency>
        <Required type="1" schemaName="msdyn_slakpi" displayName="SLA KPI" solution="msdynce_ServiceLevelAgreementExtension (9.0.22072.1003)">
          <package>msdynce_ServiceLevelAgreementAnchor (9.0.22072.1003)</package>
        </Required>
        <Dependent type="1" schemaName="msdyn_slakpi" displayName="SLA KPI" />
      </MissingDependency>
    </MissingDependencies>
  </SolutionManifest>
</ImportExportXml>
```
  into the following.  Notice the `SolutionRefs` and `PackageRefs` elements at the bottom.
  
```xml
<?xml version="1.0" encoding="utf-8"?>
<ImportExportXml version="9.2.22072.182" SolutionPackageVersion="9.2" languagecode="1033" generatedBy="CrmLive" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <SolutionManifest>
    <UniqueName>MissingDepsExample</UniqueName>
    <LocalizedNames>
      <LocalizedName description="Missing Deps Example" languagecode="1033" />
    </LocalizedNames>
    <Descriptions />
    <Version>1.0.0.0</Version>
    <Managed>2</Managed>
    <Publisher>  ... snip ... </Publisher>
    <RootComponents>
      <RootComponent type="1" schemaName="account" behavior="2" />
      <RootComponent type="1" schemaName="msdyn_customcontrolextendedsettings" behavior="2" />
      <RootComponent type="1" schemaName="msdyn_slakpi" behavior="2" />
    </RootComponents>
    <MissingDependencies>
      <MissingDependency>
        <Required type="1" schemaName="msdyn_customcontrolextendedsettings" displayName="Custom Control Extended Setting" solutionRef="msdyn_UserExperiencesExtendedSettings" />
        <Dependent type="1" schemaName="msdyn_customcontrolextendedsettings" displayName="Custom Control Extended Setting" />
      </MissingDependency>
      <MissingDependency>
        <Required type="1" schemaName="msdyn_customcontrolextendedsettings" displayName="Custom Control Extended Setting" solutionRef="msdyn_UserExperiencesExtendedSettings" />
        <Dependent type="2" schemaName="ownerid" displayName="Owner" parentSchemaName="msdyn_customcontrolextendedsettings" parentDisplayName="Custom Control Extended Setting" />
      </MissingDependency>
      <MissingDependency>
        <Required type="1" schemaName="msdyn_customcontrolextendedsettings" displayName="Custom Control Extended Setting" solutionRef="msdyn_UserExperiencesExtendedSettings" />
        <Dependent type="2" schemaName="owningbusinessunit" displayName="Owning Business Unit" parentSchemaName="msdyn_customcontrolextendedsettings" parentDisplayName="Custom Control Extended Setting" />
      </MissingDependency>
      <MissingDependency>
        <Required type="1" schemaName="msdyn_slakpi" displayName="SLA KPI" solutionRef="msdynce_ServiceLevelAgreementExtension">
          <PackageRef>msdynce_ServiceLevelAgreementAnchor</PackageRef>
        </Required>
        <Dependent type="1" schemaName="msdyn_slakpi" displayName="SLA KPI" />
      </MissingDependency>
      <SolutionRefs>
        <SolutionRef ref="msdynce_ServiceLevelAgreementExtension" solution="msdynce_ServiceLevelAgreementExtension (9.0.22072.1003)" />
        <SolutionRef ref="msdyn_UserExperiencesExtendedSettings" solution="msdyn_UserExperiencesExtendedSettings (1.0.0.317)" />
      </SolutionRefs>
      <PackageRefs>
        <PackageRef ref="msdynce_ServiceLevelAgreementAnchor" package="msdynce_ServiceLevelAgreementAnchor (9.0.22072.1003)" />
      </PackageRefs>
    </MissingDependencies>
  </SolutionManifest>
</ImportExportXml>
```

## Restore

To restore to the original solution.xml as exported by the platform run

`SolutionRefs.ps1 -solnfolder ./MySolution -restore`
