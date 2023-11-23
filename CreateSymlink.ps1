break
$symlinkParams = @{
    Path     = $PROFILE.AllUsersAllHosts
    Value    = "AllUsersAllHosts_profile.ps1"
    ItemType = 'SymbolicLink'
    Force    = $true
}
New-Item @symlinkParams