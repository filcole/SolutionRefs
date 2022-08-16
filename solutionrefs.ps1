<#
  .SYNOPSIS
  Reduces noisy diffs in the solution.xml below by moving the solution version to a separate SolutionRefs tag in the MissingDependencies
  
  .DESCRIPTION
  Examines an unpacked solution.xml, replacing each solution version number with a solution reference.
  This consolidates the version number to a single solutionRef line and makes the diffs in version control much smaller.

  When run with the -restore flag the script reverses this transformation, restoring the original solution.xml
  
  TODO
  1. Understand the relevance and variability of the id and id.connectionreferencelogicalname attributes on the MissingDependency/Required element

  NOTES/WARNINGS
  1. The power apps solution structure is proprietary and subject to change. This script may stop working at any time!
  2. This MissingDependencies section is important and should not be removed. When present missing dependencies are shown
     in the maker portal at the start of solution import.
  3. The 'solution' attribute will be removed and replaced with 'solutionref', so the order of the attributes in the
     MissingDependency/Required element can change

  .PARAMETER solnFolder
  Specifies the path to the unpacked solution. A solution.xml file must exist in the 'Other' folder.

  .PARAMETER restore
  Indicates if the SolutionRefs should be removed and the original solution.xml restored

  .EXAMPLE
  PS> SolutionRefs.ps1 -solnfolder ./MySolution

  Will convert this:

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


  into:

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
  
  PS> SolutionRefs.ps1 -solnfolder ./MySolution -restore

  Will reverse the transformation and restore the original XML
#>

param (
  [Parameter(Mandatory = $true, HelpMessage = "Enter the path to the unpacked solution")]
  [Alias("p", "path")]
  [string]$solnfolder,
  [switch]$restore = $false
)

Function GetSolutionXmlFileName {
  # Resolve any relative folder provided to script to full pathname
  $solnxml = Resolve-Path $solnfolder

  $solnxml = Join-Path $solnxml "Other"
  $solnxml = Join-Path $solnxml "Solution.xml"

  if (!( Test-Path -Path $solnxml -PathType Leaf)) {
    Write-Error "Not valid solution folder. $solnxml does not exist"
    exit
  }
  return $solnxml
}

Function CheckMissingDependencyExists([xml]$xml) {
  $nodeExists = $xml.SelectSingleNode("/ImportExportXml/SolutionManifest/MissingDependencies/MissingDependency")
  if ($null -eq $nodeExists) {
    Write-Host "No missing dependencies found. No changes required."
    exit
  }
}

Function GetSolutionRefsNode([xml]$xml) {
  $node = $xml.SelectSingleNode("/ImportExportXml/SolutionManifest/MissingDependencies/SolutionRefs")
  return $node;
}

Function GetPackageRefsNode([xml]$xml) {
  $node = $xml.SelectSingleNode("/ImportExportXml/SolutionManifest/MissingDependencies/PackageRefs")
  return $node
}

Function AddSolutionRefs([xml]$xml) {
  $nodeExists = GetSolutionRefsNode $xml
  if ($null -ne $nodeExists) {
    Write-Host "SolutionRefs already present. Has script already been run?"
    return $false
  }

  $solutionRefs = @{}
  Write-Host "Combining solutionrefs in MissingDependencies"

  # Regex to extract solution name and version
  $reSolution = '^(.*) \(([0-9.]+)\)$'

  $xml.ImportExportXml.SolutionManifest.MissingDependencies.MissingDependency | Where-Object { $_.Required.solution -ne "Active" } | ForEach-Object {
    # TODO: Handle missing 'Required' element
    # TODO: Handle misssing 'solution' attrib on 'Required' element
    $reqdSolution = $_.Required.solution
        
    if (!($reqdSolution -match $reSolution)) {
      Write-Host "Warning: Could not find solution and version in '$reqdSolution'"
      return
    }

    $solution = $matches[1] 

    if (!$solutionRefs.ContainsKey($reqdSolution)) {

      # Get number of times encountered any version of this solution already
      $count = ($solutionRefs.GetEnumerator() | Where-Object { $_.Value.Solution -eq $solution } | Measure-Object).Count

      # Only append number to end of solution ref if we've already encountered a different
      # version of this solution already.
      $solutionref = $solution
      if ($count -gt 0) {
        $solutionref = "${solution}${count}"
      }

      Write-Debug "Adding reference for $reqdSolution"
      $solutionRefs[$reqdSolution] = [PSCustomObject]@{
        SolutionRef = $solutionref
        Solution    = $solution
        #ReqdSolution = $reqdSolution
      }
    }

    $solnref = $solutionRefs[$reqdSolution].SolutionRef

    $_.Required.RemoveAttribute("solution")
    $_.Required.SetAttribute("solutionRef", $solnref)
  }

  Write-Debug ("Found" + $solutionRefs.Count + "references")
    
  # Iterate over each solution reference, sorted alphabetically and add to a new 'SolutionRefs' element
  $solutionRefElement = $xml.CreateElement("SolutionRefs")
  $solutionRefs.GetEnumerator() | Sort-Object -Property Name | ForEach-Object {
    $elem = $xml.CreateElement("SolutionRef")
    $elem.SetAttribute("ref", $_.Value.SolutionRef)
    $elem.SetAttribute("solution", $_.Key)
    $solutionRefElement.AppendChild($elem) | Out-Null
  }

  $xml.ImportExportXml.SolutionManifest.MissingDependencies.AppendChild($solutionRefElement) | Out-Null
  Write-Host "Added $($solutionRefs.Count) SolutionRefs"

  return $true
}

Function AddPackageRefs([xml]$xml) {
  $nodeExists = GetPackageRefsNode $xml
  if ($null -ne $nodeExists) {
    Write-Host "PackageRefs already present. Has script already been run?"
    return $false
  }

  $packageRefs = @{}
  Write-Host "Combining packages in MissingDependencies"

  # Regex to extract solution name and version
  $rePackage = '^(.*) \(([0-9.]+)\)$'

  $nodes = $xml.SelectNodes("/ImportExportXml/SolutionManifest/MissingDependencies/MissingDependency/Required/package")
    
  Write-Debug "Found $($nodes.Count) package elements"

  $nodes | ForEach-Object {
    $reqdPackage = $_.InnerText
        
    if (!($reqdPackage -match $rePackage)) {
      Write-Host "Warning: Could not find package and version in '$reqdPackage'"
      return
    }

    $package = $matches[1] 

    if (!$packageRefs.ContainsKey($reqdPackage)) {

      # Get number of times encountered any version of this package already
      $count = ($packageRefs.GetEnumerator() | Where-Object { $_.Value.Package -eq $package } | Measure-Object).Count

      # Only append number to end of package ref if we've already encountered a different
      # version of this package already.
      $packageref = $package
      if ($count -gt 0) {
        $packageref = "${package}${count}"
      }

      Write-Debug "Adding reference for $reqdPackage"
      $packageRefs[$reqdPackage] = [PSCustomObject]@{
        PackageRef = $packageref
        Package    = $package
      }
    }

    $packageref = $packageRefs[$reqdPackage].PackageRef

    # Create a new packageref element to replace the current 'package' element
    $elem = $xml.CreateElement("PackageRef")
    $elem.InnerText = $packageRef

    $_.ParentNode.InsertAfter($elem, $_)
    $_.ParentNode.RemoveChild($_) | Out-Null
  }

  Write-Debug ("Found" + $packageRefs.Count + "references")
    
  # Iterate over each pacakge reference, sorted alphabetically and add to a new 'PackageRefs' element
  $packageRefElement = $xml.CreateElement("PackageRefs")
  $packageRefs.GetEnumerator() | Sort-Object -Property Name | ForEach-Object {
        
    $elem = $xml.CreateElement("PackageRef")
    $elem.SetAttribute("ref", $_.Value.PackageRef)
    $elem.SetAttribute("package", $_.Key)
    $packageRefElement.AppendChild($elem) | Out-Null
  }

  $xml.ImportExportXml.SolutionManifest.MissingDependencies.AppendChild($packageRefElement) | Out-Null
  Write-Host "Added $($packageRefs.Count) PackageRefs"

  return $true
}

Function ReplaceSolutionRefs([xml]$xml) {
  $node = GetSolutionRefsNode $xml
  if ($null -eq $node) {
    Write-Host "SolutionRefs not present. No changes made"
    return $false
  }

  Write-Host "Replacing solutionRefs"
    
  # Read in solution refs
  $solutionRefs = @{}
  $xml.ImportExportXml.SolutionManifest.MissingDependencies.SolutionRefs.SolutionRef | ForEach-Object {

    $ref = $_.ref
    $solution = $_.solution

    $solutionRefs[$ref] = $solution
  }

  Write-Host "Found $($solutionRefs.Count) solutionRefs"

  # Delete SolutionRefs elements
  $xml.ImportExportXml.SolutionManifest.MissingDependencies.RemoveChild($node)

  # Replace solutionrefs in Missing Dependencies
  $xml.ImportExportXml.SolutionManifest.MissingDependencies.MissingDependency | Where-Object { $_.Required.solution -ne "Active" } | ForEach-Object {
    # TODO: Handle missing 'Required' element
    # TODO: Handle misssing 'solution' attrib on 'Required' element
    $solutionRef = $_.Required.solutionRef
    if (!$solutionRefs.ContainsKey($solutionRef)) {
      Write-Error "SolutionRef $solutionRef not found. Unable to replace. Aborting"
      Exit (1)
    }

    $solution = $solutionRefs[$solutionRef]
    Write-Debug "Replacing SolutionRef=$solutionRef solution=$solution"

    $_.Required.RemoveAttribute("solutionRef")
        
    Write-Debug "Replacing $solutionRef with $solution"
    $_.Required.SetAttribute("solution", $solution)
  }

  # We made changes
  return $true
}

Function ReplacePackageRefs([xml]$xml) {
  $node = GetPackageRefsNode $xml
  if ($null -eq $node) {
    Write-Host "PackageRefs not present. No changes made"
    return $false
  }

  Write-Host "Replacing packageRefs"
    
  # Read in package refs
  $packageRefs = @{}
 
  $packageRefList = $xml.ImportExportXml.SolutionManifest.MissingDependencies.PackageRefs.PackageRef
  if ($null -ne $packageRefList) {
    $packageRefList | ForEach-Object {
      $ref = $_.ref
      $package = $_.package

      $packageRefs[$ref] = $package
    }
  }

  Write-Host "Found $($packageRefs.Count) packageRefs"

  # Delete PackageRefs element
  $xml.ImportExportXml.SolutionManifest.MissingDependencies.RemoveChild($node)

  $nodes = $xml.SelectNodes("/ImportExportXml/SolutionManifest/MissingDependencies/MissingDependency/Required/PackageRef")

  # Replace packagerefs in Missing Dependencies
  $nodes | ForEach-Object {

    $packageRef = $_.InnerText
    if (!$packageRefs.ContainsKey($packageRef)) {
      Write-Error "PackageRef $packageRef not found. Unable to replace. Aborting"
      Exit (1)
    }

    $package = $packageRefs[$packageRef]
    Write-Debug "Replacing $packageRef with $package"

    # Create a new package element to replace the current 'PackageRef' element
    $elem = $xml.CreateElement("package")
    $elem.InnerText = $package

    $_.ParentNode.InsertAfter($elem, $_)
    $_.ParentNode.RemoveChild($_) | Out-Null
  }

  # We made changes
  return $true
}

Function SaveXml ([xml]$xmlDoc, [string]$fileName) {
  # Settings object will instruct how the xml elements are written to the file
  $settings = New-Object System.Xml.XmlWriterSettings
  $settings.Indent = $true
  # NewLineChars will affect all newlines
  $settings.NewLineChars = "`r`n"
  # Set UTF-8 encoding (without BOM)
  $settings.Encoding = New-Object System.Text.UTF8Encoding( $false )

  $w = [System.Xml.XmlWriter]::Create($fileName, $settings)
  try {
    $xmlDoc.Save( $w )
    Write-Host "Saved $filename"
  }
  finally {
    $w.Dispose()
  }
}

# MAIN PROGRAM

$fileName = GetSolutionXmlFileName

# Read solution xml
Write-Host "Reading ${fileName}"
[xml]$xml = Get-Content $fileName
$modified = $false

CheckMissingDependencyExists $xml

if ($restore -eq $true) {
  $solModified = ReplaceSolutionRefs($xml)
  $pacModified = ReplacePackageRefs($xml)
  $modified = $solModified -or $pacModified

}
else {
  $solModified = AddSolutionRefs($xml)
  $pacModified = AddPackageRefs($xml)
  $modified = $solModified -or $pacModified
}

if ($modified -eq $true) {
  SaveXml $xml $fileName
}