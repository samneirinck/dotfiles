$profileDir = Split-Path -Parent $PROFILE

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