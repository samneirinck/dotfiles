$profileDir = Split-Path -Parent $PROFILE

"1. Setting up symbolic links"
# Symbolic link all directories in powershell/
Get-ChildItem -Directory powershell | ForEach-Object {
    $symPath = Join-Path $profileDir $_.BaseName 
    cmd /c mklink /d "$symPath" $_.FullName
}

# Symbolic link all files in powershell/
Get-ChildItem -File powershell | ForEach-Object {
    $symPath = Join-Path $profileDir $_.Name 
    cmd /c mklink "$symPath" $_.FullName
}

# Symbolic link all files in conemu/
Get-ChildItem -File conemu | ForEach-Object {
    $symPath = Join-Path %appdata% $_.Name 
    cmd /c mklink "$symPath" $_.FullName
}

""
"2. Installing/Updating modules"
Install-Module -Name @('posh-git', 'posh-docker', 'oh-my-posh') -Scope CurrentUser
Update-Module