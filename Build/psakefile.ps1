#requires -Version 3
. '.\psakefile-tools.ps1'

Properties {
  $solutionFileName = $null
  $build_platform = $null
  $configuration = $null
  $project_name = $null
  $app_name = $null
  $display_name = $null
  $product_id = $null
}

Task TestProperties {
  Assert ($solutionFileName -ne $null) 'Solution file name should not be null'
  Assert ($build_platform -ne $null) 'Build platform should not be null'
  Assert ($configuration -ne $null) 'Configuration should not be null'
  Assert ($app_name -ne $null) 'App Name should be null'
  Assert ($project_name -ne $null) 'Project Name should be null'
  Assert ($display_name -ne $null) 'Display Name should be null'
  Assert ($product_id -ne $null) 'Product Id should be null'
}

# our default task, which is used if no task is specified
Task Default -Depends Build

Task Build -Depends TestProperties, Clean, Version {
  Write-Host -Object 'Building solution' -ForegroundColor DarkCyan
  return Exec {
    &('C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe') (Get-SolutionPath -solutionName $solutionFileName) /p:Configuration="$configuration" /p:Platform="$build_platform" /v:q
  }
}

Task Clean {
  Write-Host -Object 'Cleaning solution' -ForegroundColor DarkCyan
  Exec {
    &('C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe') (Get-SolutionPath -solutionName $solutionFileName) /p:Configuration="$configuration" /p:Platform="$build_platform" /v:q /t:Clean
  }
}

Task Version {
  $appx_file_path = Get-ProjectFilePath -projectName $project_name -fileName 'Package.appxmanifest'
  $XMLfile = Get-ProjectFileXmlObject -filePath $appx_file_path
  $version = $XMLfile.Package.Identity.Version
  Write-Host -Object "Current version number = $version"
  $major = $version.Split('.')[0]
  $minor = $version.Split('.')[1]
  $release = Get-Date -UFormat %j%H
  $buildNumber = 0
  $version = "$major.$minor.$release.$buildNumber"
  Write-Host -Object "Updating appxmanifest file with version number $version" -ForegroundColor DarkCyan

  #Save the new version number
  $XMLfile.Package.Identity.Version = $version
  $XMLfile.Package.Identity.Name = $app_name
  $XMLfile.Package.Applications.Application.VisualElements.DisplayName = $display_name
  $XMLfile.Package.PhoneIdentity.PhoneProductId = $product_id
  $XMLfile.Package.Properties.DisplayName = $display_name

  # set the file as read write and save
  Set-ItemProperty ($appx_file_path) -Name IsReadOnly -Value $false
  $XMLfile.save($appx_file_path)
  Write-Host -Object 'Updated the appxmanifest file' -ForegroundColor DarkCyan

  $association_file_path = Get-ProjectFilePath -projectName $project_name -fileName 'Package.StoreAssociation.xml'
  $XMLfile = Get-ProjectFileXmlObject -filePath $association_file_path
  $XMLfile.StoreAssociation.ProductReservedInfo.MainPackageIdentityName = $app_name
  $XMLfile.StoreAssociation.ProductReservedInfo.ReservedNames.ReservedName = $display_name

  # set the file as read write and save
  Set-ItemProperty ($association_file_path) -Name IsReadOnly -Value $false
  $XMLfile.save($association_file_path)
  Write-Host -Object 'Updated the store association file' -ForegroundColor DarkCyan
}

Task RestorePackages {
  Write-Host -Object 'Start restoring Nuget packages' -ForegroundColor DarkCyan
  $nuget_executable_file_path = $PSScriptRoot + '\NuGet.exe'
  $nuget_config_file_path = $PSScriptRoot + '\NuGet.Config'
  Exec {
    &($nuget_executable_file_path) restore (Get-SolutionPath -solutionName $solutionFileName) -ConfigFile $nuget_config_file_path -NoCache -MSBuildVersion 14
  }
}

Task Test {
  # executes unit tests
}

Task Validate {
  # executes the WACK
}
