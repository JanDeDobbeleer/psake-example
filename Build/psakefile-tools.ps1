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