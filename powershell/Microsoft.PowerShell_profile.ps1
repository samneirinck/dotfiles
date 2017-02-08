# Modules
Import-Module oh-my-posh
Import-Module posh-docker

# Themes
Set-Theme SamAgnoster

# Prevent password query for git operations with SSH key
if ((Get-SshAgent) -eq 0) {
    Start-SshAgent -Quiet
}
