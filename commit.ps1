# PowerShell helper script to initialize git repo and commit current changes
# Usage: Open PowerShell in project root and run: .\commit.ps1

# Check for git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not available in your PATH. Please install Git (https://git-scm.com/)."
    exit 1
}

# Initialize git if needed
if (-not (Test-Path .git)) {
    git init
    Write-Host "Initialized new git repository."
}

# Set local user config if not set (optional)
# git config user.name "Your Name"
# git config user.email "your.email@example.com"

# Stage changes and commit
git add -A

# Commit message
$message = 'TODO App Working version'
# Check if there are staged changes
$diffIndex = git diff --cached --name-only
if (-not $diffIndex) {
    Write-Host "No changes to commit."
    exit 0
}

# Commit
git commit -m "$message"
Write-Host "Committed changes with message: $message"

# Show last commit
git --no-pager log -1 --stat
