<#
  .SYNOPSIS
  Reduces noisy diffs in the solution.xml below by moving the solution version to a separate SolutionRefs tag in the MissingDependencies
  
  .DESCRIPTION
  Examines an unpacked solution.xml, replacing each solution version number with a solution reference.
  This consolidates the version number to a single solutionRef line and makes the diffs in version control much smaller.

  When run with the -restore flag the script reverses this transformation, restoring the original solution.xml
  
  .TODO
  Understand the relevance and variability of the id and id.connectionreferencelogicalname attributes on the MissingDependency/Required element

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
  PS> AddSolutionRefs.ps1 -solnfolder ./MySolution

  PS> AddSolutionRefs.ps1 -solnfolder ./MySolution -restore
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
    if ($nodeExists -eq $null) {
        Write-Host "No missing dependencies found. No changes required."
        exit
    }
}

Function GetSolutionRefsNode([xml]$xml) {
    $node = $xml.SelectSingleNode("/ImportExportXml/SolutionManifest/MissingDependencies/SolutionRefs")
    return $node;
}

Function AddSolutionRefs([xml]$xml)
{
    $nodeExists = GetSolutionRefsNode $xml
    if ($nodeExists -ne $null) {
        Write-Host "SolutionRefs already present. Has script already been run?"
        return $false;
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
                Solution = $solution
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
    $solutionRefs.GetEnumerator() | Sort-Object $_.Key | ForEach-Object {
        
        $elem = $xml.CreateElement("SolutionRef");
        $elem.SetAttribute("ref", $_.Value.SolutionRef)
        $elem.SetAttribute("solution", $_.Key)
        $solutionRefElement.AppendChild($elem) | Out-Null
    }

    $xml.ImportExportXml.SolutionManifest.MissingDependencies.AppendChild($solutionRefElement) | Out-Null
    Write-Host "Added $($solutionRefs.Count) SolutionRefs"

    return $true
}

Function ReplaceSolutionRefs([xml]$xml)
{
    $node = GetSolutionRefsNode $xml
    if ($node -eq $null) {
        Write-Host "SolutionRefs not present. No changes made"
        return $false
    }

    Write-Host "Replacing solutionRefs"
    
    # Read in solution refs
    $solutionRefs = @{}
    $xml.ImportExportXml.SolutionManifest.MissingDependencies.SolutionRefs.SolutionRef | ForEach-Object {

        $ref = $_.ref
        $solution = $_.solution

        $solutionRefs[$ref] = [PSCustomObject]@{
            SolutionRef = $ref
            Solution = $solution
        }
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

        $refInfo = $solutionRefs[$solutionRef]

        $ref = $solutionRef
        $solution = $refInfo.Solution
        Write-Debug "Replacing Ref=$ref solution=$solution"

        $_.Required.RemoveAttribute("solutionRef")
        
        Write-Debug "Replacing $solutionRef with $solution"
        $_.Required.SetAttribute("solution", $solution)
    }

    # We made changes
    return $true
}

Function SaveXml ([xml]$xmlDoc, [string]$fileName) {
    # Settings object will instruct how the xml elements are written to the file
    $settings = New-Object System.Xml.XmlWriterSettings
    $settings.Indent = $true
    #NewLineChars will affect all newlines
    $settings.NewLineChars ="`r`n"
    #Set an optional encoding, UTF-8 is the most used (without BOM)
    #$settings.Encoding = New-Object System.Text.UTF8Encoding( $false )

    $w = [System.Xml.XmlWriter]::Create($fileName, $settings)
    try{
        $xmlDoc.Save( $w )
        Write-Host "Saved $filename"
    } finally{
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
    $modified = ReplaceSolutionRefs($xml)
} else {
    $modified = AddSolutionRefs($xml)
}

if ($modified -eq $true) {
    SaveXml $xml $fileName
}