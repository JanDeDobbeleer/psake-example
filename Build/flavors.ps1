#requires -Version 1
Task Default -Depends Production

Task Production {
  return Invoke-psake psakefile.ps1 Build -properties @{
    'solutionFileName' = 'Dummy.sln'
    'build_platform' = 'ARM'
    'configuration'  = 'Release'
    'project_name'   = 'Dummy.UWP'
    'app_name'       = 'Dummy'
    'product_id'     = '5f99e69a-9f7b-88e4-86aa-c0f67dc5484f'
    'display_name'   = 'Dummy'
  }
}

Task Beta {
  return Invoke-psake psakefile.ps1 Build -properties @{
    'solutionFileName' = 'Dummy.sln'
    'build_platform' = 'ARM'
    'configuration'  = 'Release'
    'project_name'   = 'Dummy.UWP'
    'app_name'       = 'Dummy Beta'
    'product_id'     = '5f99e69a-9f7b-88e4-86aa-c0f67dc5484f'
    'display_name'   = 'Dummy Beta'
  }
}