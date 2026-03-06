@{
    # Module manifest for GitPrompt
    RootModule = 'GitPrompt.psm1'
    ModuleVersion = '1.0.0'
    GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
    Author = 'Miguel'
    CompanyName = 'Mottum'
    Copyright = '(c) 2026 Miguel. MIT License.'
    Description = 'PowerShell prompt with git branch display and monorepo support. Shows both parent and nested repository branches when working in monorepo structures.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Get-GitBranchInfo', 'Set-GitPrompt')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('git', 'prompt', 'monorepo', 'terminal', 'powershell')
            LicenseUri = 'https://github.com/YOUR_USERNAME/ps-git-prompt/blob/main/LICENSE'
            ProjectUri = 'https://github.com/YOUR_USERNAME/ps-git-prompt'
            ReleaseNotes = 'Initial release with monorepo support.'
        }
    }
}
