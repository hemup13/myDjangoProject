<<<<<<< HEAD
# git_push.ps1
# Usage: Run this from the project root in PowerShell.
# - If GitHub CLI (gh) is installed and authenticated, the script can create a remote repo and push.
# - Otherwise, you can provide (or create) a remote repository URL and push manually.

param(
    [string]$RepoName = $(Split-Path -Leaf (Get-Location)),
    [string]$Visibility = 'public', # or private
    [string]$RemoteURL = ''
)

function Ensure-GitInstalled {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "Git not found. Please install Git from https://git-scm.com/downloads and try again."
        exit 1
    }
}

function Ensure-RepoInitialized {
    if (-not (Test-Path .git)) {
        git init
        Write-Host "Initialized new git repository"
    }
}

function Configure-LocalUserIfMissing {
    $name = git config --get user.name 2>$null
    $email = git config --get user.email 2>$null
    if (-not $name) {
        $inputName = Read-Host 'Enter git user.name (e.g., "Your Name")'
        if ($inputName) { git config user.name "$inputName" }
    }
    if (-not $email) {
        $inputEmail = Read-Host 'Enter git user.email (e.g., your.email@example.com)'
        if ($inputEmail) { git config user.email "$inputEmail" }
    }
}

function StageAndCommit {
    git add -A
    $status = git status --porcelain
    if (-not $status) {
        Write-Host "No changes to commit."
        return $false
    }
    git commit -m "TODO App Working version"
    return $true
}

function Create-RepoWithGH {
    param($repo,$visibility)
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        Write-Host "Creating repo using GitHub CLI (gh)..."
        gh repo create $repo --$visibility --source=. --remote=origin --push --confirm
        return $true
    }
    return $false
}

function Add-RemoteAndPush {
    param($remote)
    if (-not $remote) { Write-Error 'No remote URL provided'; return }
    # If remote exists, set url; else add
    & git remote get-url origin > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Remote 'origin' already exists, updating URL to $remote"
        git remote set-url origin $remote
    } else {
        git remote add origin $remote
    }

    # Ensure default branch is main
    $branch = git rev-parse --abbrev-ref HEAD
    if ($branch -ne 'main') {
        git branch -M main
    }

    git push -u origin main
}

# START
Ensure-GitInstalled
Ensure-RepoInitialized
Configure-LocalUserIfMissing
$committed = StageAndCommit
if (-not $committed) { Write-Host 'Nothing committed; exiting.'; exit 0 }

# If gh is available, try to create a GitHub repo and push
if (Get-Command gh -ErrorAction SilentlyContinue) {
    # If RemoteURL is provided, prefer it; otherwise create with gh
    if ($RemoteURL) {
        Add-RemoteAndPush -remote $RemoteURL
        exit 0
    }
    Write-Host 'GitHub CLI detected. Asking to create remote repo...'
    $createWithGH = Read-Host "Create GitHub repo with gh CLI named '$RepoName' (y/n)?"
    if ($createWithGH -match '^[Yy]') {
        Create-RepoWithGH -repo $RepoName -visibility $Visibility
        exit 0
    }
}

# If no gh or user chose not to use it, ask for remote URL
if (-not $RemoteURL) {
    $RemoteURL = Read-Host 'Enter the remote repository URL (https://github.com/<owner>/<repo>.git)'
}
Add-RemoteAndPush -remote $RemoteURL
Write-Host 'Push complete.'
=======
# git_push.ps1
# Usage: Run this from the project root in PowerShell.
# - If GitHub CLI (gh) is installed and authenticated, the script can create a remote repo and push.
# - Otherwise, you can provide (or create) a remote repository URL and push manually.

param(
    [string]$RepoName = $(Split-Path -Leaf (Get-Location)),
    [string]$Visibility = 'public', # or private
    [string]$RemoteURL = ''
)

function Ensure-GitInstalled {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "Git not found. Please install Git from https://git-scm.com/downloads and try again."
        exit 1
    }
}

function Ensure-RepoInitialized {
    if (-not (Test-Path .git)) {
        git init
        Write-Host "Initialized new git repository"
    }
}

function Configure-LocalUserIfMissing {
    $name = git config --get user.name 2>$null
    $email = git config --get user.email 2>$null
    if (-not $name) {
        $inputName = Read-Host 'Enter git user.name (e.g., "Your Name")'
        if ($inputName) { git config user.name "$inputName" }
    }
    if (-not $email) {
        $inputEmail = Read-Host 'Enter git user.email (e.g., your.email@example.com)'
        if ($inputEmail) { git config user.email "$inputEmail" }
    }
}

function StageAndCommit {
    git add -A
    $status = git status --porcelain
    if (-not $status) {
        Write-Host "No changes to commit."
        return $false
    }
    git commit -m "TODO App Working version"
    return $true
}

function Create-RepoWithGH {
    param($repo,$visibility)
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        Write-Host "Creating repo using GitHub CLI (gh)..."
        gh repo create $repo --$visibility --source=. --remote=origin --push --confirm
        return $true
    }
    return $false
}

function Add-RemoteAndPush {
    param($remote)
    if (-not $remote) { Write-Error 'No remote URL provided'; return }
    # If remote exists, set url; else add
    & git remote get-url origin > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Remote 'origin' already exists, updating URL to $remote"
        git remote set-url origin $remote
    } else {
        git remote add origin $remote
    }

    # Ensure default branch is main
    $branch = git rev-parse --abbrev-ref HEAD
    if ($branch -ne 'main') {
        git branch -M main
    }

    git push -u origin main
}

# START
Ensure-GitInstalled
Ensure-RepoInitialized
Configure-LocalUserIfMissing
$committed = StageAndCommit
if (-not $committed) { Write-Host 'Nothing committed; exiting.'; exit 0 }

# If gh is available, try to create a GitHub repo and push
if (Get-Command gh -ErrorAction SilentlyContinue) {
    # If RemoteURL is provided, prefer it; otherwise create with gh
    if ($RemoteURL) {
        Add-RemoteAndPush -remote $RemoteURL
        exit 0
    }
    Write-Host 'GitHub CLI detected. Asking to create remote repo...'
    $createWithGH = Read-Host "Create GitHub repo with gh CLI named '$RepoName' (y/n)?"
    if ($createWithGH -match '^[Yy]') {
        Create-RepoWithGH -repo $RepoName -visibility $Visibility
        exit 0
    }
}

# If no gh or user chose not to use it, ask for remote URL
if (-not $RemoteURL) {
    $RemoteURL = Read-Host 'Enter the remote repository URL (https://github.com/<owner>/<repo>.git)'
}
Add-RemoteAndPush -remote $RemoteURL
Write-Host 'Push complete.'
>>>>>>> 1ff88563d0bad54175822ce277dca74fe04e244c
