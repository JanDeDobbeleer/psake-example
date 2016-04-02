#requires -Version 1
Properties {  
	$solutionFileName = $null
	$build_platform = $null
	$configuration = $null
	$project_name = $null
	$app_name = $null
	$display_name = $null
	$product_id = $null
}

# our default task, which is used if no task is specified
Task Default -Depends Build

Task Build -Depends TestProperties, Clean, Version {  
	Write-Host "Building solution" -ForegroundColor DarkCyan	
	$solutionRoot = (Get-Item $PSScriptRoot).Parent.FullName	
	$solution_file_path = $solutionRoot + '\' + $solutionFileName
	return Exec { &("C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe") $solution_file_path /p:Configuration="$configuration" /p:Platform="$build_platform" /v:q }
}

Task RestorePackages {
	Write-Host 'Start restoring Nuget packages' -ForegroundColor DarkCyan
	$solutionRoot = (Get-Item $PSScriptRoot).Parent.FullName
	$nuget_executable_file_path = $solutionRoot + '\.nuget\NuGet.exe'
    $nuget_config_file_path = $solutionRoot + '\.nuget\NuGet.Config'
	$solution_file_path = $solutionRoot + '\' + $solutionFileName
	Exec { &($nuget_executable_file_path) restore $solution_file_path -ConfigFile $nuget_config_file_path -NoCache }
}

Task TestProperties {  
	Assert ($solutionFileName -ne $null) "Solution file name should not be null"
	Assert ($build_platform -ne $null) "Build platform should not be null"
	Assert ($configuration -ne $null) "Configuration should not be null"
	Assert ($app_name -ne $null) "App Name should be null"
	Assert ($project_name -ne $null) "Project Name should be null"
	Assert ($display_name -ne $null) "Display Name should be null"
	Assert ($product_id -ne $null) "Product Id should be null"
}

Task Test {
  # executes unit tests
}

Task Validate {
  # executes the WACK
}

Task Version {
	$solutionRoot = (Get-Item $PSScriptRoot).Parent.FullName
	$XMLfile=NEW-OBJECT XML
	$appx_file_path = $solutionRoot + "\$project_name\Package.appxmanifest"
	$XMLfile.Load($appx_file_path)
	$version = $XMLFile.Package.Identity.Version
	Write-Host "Current version number = $version"
	$major = $version.Split('.')[0]
	$minor = $version.Split('.')[1]
	$release = Get-Date -UFormat %j%H
	$buildNumber = 0
	$version = "$major.$minor.$release.$buildNumber";
	Write-Host "Updating appxmanifest file with version number $version" -ForegroundColor DarkCyan

	#Save the new version number
	$XMLFile.Package.Identity.Version = $version
	$XMLFile.Package.Identity.Name = $app_name
	$XMLFile.Package.Applications.Application.VisualElements.DisplayName = $display_name
	$XMLFile.Package.PhoneIdentity.PhoneProductId = $product_id
	$XMLFile.Package.Properties.DisplayName = $display_name

	# set the file as read write and save
	Set-ItemProperty ($appx_file_path) -name IsReadOnly -value $false
	$XMLFile.save($appx_file_path)
	Write-Host "Updated the appxmanifest file" -ForegroundColor DarkCyan

	$XMLfile=NEW-OBJECT XML
	$association_file_path = $solutionRoot + "\$project_name\Package.StoreAssociation.xml"
	$XMLfile.Load($association_file_path)
	$XMLFile.StoreAssociation.ProductReservedInfo.MainPackageIdentityName = $app_name
	$XMLFile.StoreAssociation.ProductReservedInfo.ReservedNames.ReservedName = $display_name

	# set the file as read write and save
	Set-ItemProperty ($association_file_path) -name IsReadOnly -value $false
	$XMLFile.save($association_file_path)
	Write-Host "Updated the store association file" -ForegroundColor DarkCyan
}

Task Clean {
	Write-Host "Cleaning solution" -ForegroundColor DarkCyan	
	$solutionRoot = (Get-Item $PSScriptRoot).Parent.FullName	
	$solution_file_path = $solutionRoot + '\' + $solutionFileName
	Exec { &("C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe") $solution_file_path /p:Configuration="$configuration" /p:Platform="$build_platform" /v:q /t:Clean }
}