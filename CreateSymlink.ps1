$symlinkParams = @{
    Path     = $PROFILE.AllUsersAllHosts
    Value    = "$PSScriptRoot\AllUsersAllHosts_profile.ps1"
    ItemType = 'SymbolicLink'
    Force    = $true
}
New-Item @symlinkParams
