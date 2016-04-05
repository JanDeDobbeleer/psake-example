#requires -Version 3
function Get-SolutionFolder
{
    return (Get-Item $PSScriptRoot).Parent.FullName
}

function Get-SolutionPath
{
    param
    (
        [string]
        $solutionName
    )
  
    return ((Get-SolutionFolder) + "\$solutionName")
}

function Get-ProjectFilePath
{
    param
    (
        [string]
        $projectName,
   
        [string]
        $fileName
    )
  
    return ((Get-SolutionFolder) + "\$project_name\$fileName")
}

function Get-ProjectFileXmlObject
{
    param
    (
        [string]
        $filePath
    )
  
  
    $XMLfile = New-Object -TypeName XML
    $XMLfile.Load($filePath)
    return $XMLfile
}

function Get-AppxPackageLocation
{
    param
    (
        [string]
        $projectName
    )

    $packagesPath = (Get-SolutionFolder) + '\' + $project_name + '\AppPackages\'
    return Get-ChildItem -Path $packagesPath -Directory |
    Sort-Object -Property CreationTime |
    Select-Object -Last 1 |
    Get-ChildItem -Filter '*.appx' |
    Select-Object -First 1 |
    ForEach-Object -Process {
        $_.FullName
    }
}
