# GitPrompt.psm1 - PowerShell Git Branch Prompt with Monorepo Support
# https://github.com/YOUR_USERNAME/ps-git-prompt

function Get-GitBranchInfo {
    <#
    .SYNOPSIS
        Gets git branch information for current directory, including parent repo in monorepo setups.
    .DESCRIPTION
        Returns branch info for current repo and parent repo (if in a nested git structure).
    .OUTPUTS
        PSCustomObject with CurrentBranch and ParentBranch properties.
    #>
    [CmdletBinding()]
    param()
    
    $result = [PSCustomObject]@{
        CurrentBranch = $null
        ParentBranch = $null
        CurrentRoot = $null
        ParentRoot = $null
    }
    
    $currentBranch = git branch --show-current 2>$null
    if (-not $currentBranch) {
        return $result
    }
    
    $result.CurrentBranch = $currentBranch
    $result.CurrentRoot = git rev-parse --show-toplevel 2>$null
    
    if ($result.CurrentRoot) {
        $parentDir = Split-Path $result.CurrentRoot -Parent
        if ($parentDir) {
            Push-Location $parentDir
            $parentBranch = git branch --show-current 2>$null
            if ($parentBranch) {
                $result.ParentBranch = $parentBranch
                $result.ParentRoot = git rev-parse --show-toplevel 2>$null
            }
            Pop-Location
        }
    }
    
    return $result
}

function Set-GitPrompt {
    <#
    .SYNOPSIS
        Sets the PowerShell prompt to display git branch information.
    .DESCRIPTION
        Configures the prompt function to show current git branch, with support
        for monorepo structures showing both parent and nested repo branches.
    .PARAMETER ParentColor
        Color for the parent repo branch. Default: Magenta
    .PARAMETER CurrentColor
        Color for the current/nested repo branch. Default: Cyan
    .PARAMETER SeparatorColor
        Color for the "/" separator. Default: White
    .EXAMPLE
        Set-GitPrompt
        Sets the default git prompt.
    .EXAMPLE
        Set-GitPrompt -ParentColor Yellow -CurrentColor Green
        Sets a custom colored git prompt.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [ConsoleColor]$ParentColor = [ConsoleColor]::Magenta,
        
        [Parameter()]
        [ConsoleColor]$CurrentColor = [ConsoleColor]::Cyan,
        
        [Parameter()]
        [ConsoleColor]$SeparatorColor = [ConsoleColor]::White
    )
    
    $script:GitPromptParentColor = $ParentColor
    $script:GitPromptCurrentColor = $CurrentColor
    $script:GitPromptSeparatorColor = $SeparatorColor
    
    function global:prompt {
        $branchInfo = Get-GitBranchInfo
        
        if ($branchInfo.CurrentBranch) {
            if ($branchInfo.ParentBranch -and $branchInfo.ParentBranch -ne $branchInfo.CurrentBranch) {
                Write-Host "[$($branchInfo.ParentBranch)" -NoNewline -ForegroundColor $script:GitPromptParentColor
                Write-Host "/" -NoNewline -ForegroundColor $script:GitPromptSeparatorColor
                Write-Host "$($branchInfo.CurrentBranch)] " -NoNewline -ForegroundColor $script:GitPromptCurrentColor
            } else {
                Write-Host "[$($branchInfo.CurrentBranch)] " -NoNewline -ForegroundColor $script:GitPromptCurrentColor
            }
        }
        
        "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
    }
}

# Export functions
Export-ModuleMember -Function Get-GitBranchInfo, Set-GitPrompt
