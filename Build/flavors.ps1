#requires -Version 1
Task Default -Depends ProductionCI

Task ProductionCI {
  Invoke-psake psakefile.ps1 CI -properties @{
    'solutionFileName' = 'Dummy.sln'
    'build_platform' = 'x86'
    'configuration'  = 'Release'
    'project_name'   = 'Dummy.UWP.Test'
  }
}

Task ProductionCD {
  Invoke-psake psakefile.ps1 CD -properties @{
    'solutionFileName' = 'Dummy.sln'
    'build_platform' = 'ARM'
    'configuration'  = 'Release'
    'project_name'   = 'Dummy.UWP'
    'app_name'       = 'Dummy'
    'product_id'     = '5f99e69a-9f7b-88e4-86aa-c0f67dc5484f'
    'display_name'   = 'Dummy'
  }
}

Task BetaCD {
  Invoke-psake psakefile.ps1 CD -properties @{
    'solutionFileName' = 'Dummy.sln'
    'build_platform' = 'ARM'
    'configuration'  = 'Release'
    'project_name'   = 'Dummy.UWP'
    'app_name'       = 'Dummy Beta'
    'product_id'     = '5f99e69a-9f7b-88e4-86aa-c0f67dc5484f'
    'display_name'   = 'Dummy Beta'
  }
}