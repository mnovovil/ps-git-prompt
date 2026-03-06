# ps-git-prompt

A PowerShell module that displays git branch information in your terminal prompt, with special support for **monorepo** structures.

![Example](docs/example.png)

## Features

- 🔄 **Auto-updating** - Branch name updates automatically as you navigate
- 📦 **Monorepo support** - Shows both parent and nested repo branches (e.g., `[main/dev]`)
- 🎨 **Customizable colors** - Configure colors for parent/current branch
- ⚡ **Lightweight** - Minimal overhead on each prompt

## Installation

### Option 1: Manual Installation

1. Clone this repository:
   ```powershell
   git clone https://github.com/mnovovil/ps-git-prompt.git
   ```

2. Import the module in your PowerShell profile:
   ```powershell
   # Add to your $PROFILE
   Import-Module "C:\path\to\ps-git-prompt\GitPrompt.psm1"
   Set-GitPrompt
   ```

### Option 2: Copy to PowerShell Modules

1. Copy the module to your PowerShell modules directory:
   ```powershell
   Copy-Item -Recurse ps-git-prompt "$env:USERPROFILE\Documents\PowerShell\Modules\GitPrompt"
   ```

2. Add to your profile:
   ```powershell
   Import-Module GitPrompt
   Set-GitPrompt
   ```

### Option 3: Quick Install (One-liner)

Add this directly to your `$PROFILE`:

```powershell
# Git Branch Prompt with Monorepo Support
function prompt {
    $currentBranch = git branch --show-current 2>$null
    $parentBranch = $null
    
    if ($currentBranch) {
        $currentRoot = git rev-parse --show-toplevel 2>$null
        if ($currentRoot) {
            $parentDir = Split-Path $currentRoot -Parent
            if ($parentDir) {
                Push-Location $parentDir
                $parentBranch = git branch --show-current 2>$null
                Pop-Location
            }
        }
        
        if ($parentBranch -and $parentBranch -ne $currentBranch) {
            Write-Host "[$parentBranch" -NoNewline -ForegroundColor Magenta
            Write-Host "/" -NoNewline -ForegroundColor White
            Write-Host "$currentBranch] " -NoNewline -ForegroundColor Cyan
        } else {
            Write-Host "[$currentBranch] " -NoNewline -ForegroundColor Cyan
        }
    }
    "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}
```

## Usage

### Basic Usage

```powershell
Import-Module GitPrompt
Set-GitPrompt
```

Your prompt will now show:
- `[main]` - When in a regular git repo on the main branch
- `[main/dev]` - When in a nested repo (dev branch) inside a parent repo (main branch)
- No prefix - When not in a git repository

### Custom Colors

```powershell
Set-GitPrompt -ParentColor Yellow -CurrentColor Green -SeparatorColor Gray
```

### Get Branch Info Programmatically

```powershell
$info = Get-GitBranchInfo
$info.CurrentBranch  # "dev"
$info.ParentBranch   # "main"
```

## How It Works

1. On each prompt, the module checks if you're in a git repository
2. If yes, it gets the current branch name
3. It then checks if the parent directory of the repo root is also a git repository
4. If there's a parent repo with a different branch, it displays both: `[parent/current]`

## Requirements

- PowerShell 5.1 or later
- Git installed and available in PATH

## License

MIT License - see [LICENSE](LICENSE) file.

## Contributing

Contributions welcome! Please open an issue or PR.
