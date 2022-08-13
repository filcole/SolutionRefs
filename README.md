# SolutionRefs

Attempt to reduce noisy diffs in MissingDependencies section of solution.xml

## Usage

`AddSolutionRefs.ps1 -solnfolder ./MySolution`

  Will convert this:

```xml
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
```
  into the following.  Notice the `SolutionRefs` elements at the bottom:
  
```xml
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
          <package>msdynce_ServiceLevelAgreementAnchor (9.0.22072.1003)</package>
        </Required>
        <Dependent type="1" schemaName="msdyn_slakpi" displayName="SLA KPI" />
      </MissingDependency>
      <SolutionRefs>
        <SolutionRef ref="msdynce_ServiceLevelAgreementExtension" solution="msdynce_ServiceLevelAgreementExtension (9.0.22072.1003)" />
        <SolutionRef ref="msdyn_UserExperiencesExtendedSettings" solution="msdyn_UserExperiencesExtendedSettings (1.0.0.317)" />
      </SolutionRefs>
    </MissingDependencies>
```

## Restore

To restore to the original solution.xml as exported by the platform run

`AddSolutionRefs.ps1 -solnfolder ./MySolution -restore`
