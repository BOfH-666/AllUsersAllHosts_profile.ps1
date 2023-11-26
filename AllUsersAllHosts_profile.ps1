$ConsoleStartPath = 'C:\_Sample'

$host.PrivateData.ErrorBackgroundColor = $host.UI.RawUI.BackgroundColor
$host.PrivateData.ErrorForegroundColor = 'green'

$WID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$WinPrp = New-Object System.Security.Principal.WindowsPrincipal($WID)
$Admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$IsAdmin = $WinPrp.IsInRole($Admin)

if ($IsAdmin) {
    $PromptColor = 'Red'
}
else {
    $PromptColor = 'Gray'
}
function prompt {
    if ($?) {
        $backgroundColor = 'DarkGreen'
    }
    else {
        $backgroundColor = 'DarkRed'
    }
    $History = Get-History
    if ($History) {
        $DurationString = ' {0:c} ' -f (New-TimeSpan ($History)[-1].StartExecutionTime ($History)[-1].EndExecutionTime -ErrorAction SilentlyContinue )
    }
    Write-Host " $(Get-Date -Format 'ddd, dd.MMMyyyy HH:mm:ss') " -ForegroundColor White -BackgroundColor Darkgray -NoNewline
    Write-Host ' ' -NoNewline
    Write-Host " $DurationString " -ForegroundColor White -BackgroundColor $backgroundColor -NoNewline
    Write-Host ' '
    Write-Host " $pwd " -ForegroundColor White -BackgroundColor DarkBlue -NoNewline
    Write-Host ' '
    Write-Host -NoNewline 'PS> ' -ForegroundColor $PromptColor
    "`b"
}

$OSInfo = Get-CimInstance -ClassName CIM_OperatingSystem
$OS = $OSInfo.Caption + ' - ' + $OSInfo.OSArchitecture + ' - ' + "[$ENV:USERNAME] @ [$ENV:ComputerName]" + ' - ' + 'BootTime: ' + $OSInfo.LastBootUpTime.DateTime 
$Host.UI.RawUI.WindowTitle = $OS + '  -   Session started: ' + $(Get-Date -Format 'ddd dd.MM.yyyy - HH:mm ')

$sysuptime = (Get-Date) - $OSInfo.LastBootUpTime
Write-Host "'$($ENV:ComputerName)' has been up for: $($sysuptime.days) days $($sysuptime.hours) hours $($sysuptime.minutes) minutes" -ForegroundColor cyan

Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType = "3"' |
Select-Object -Property DeviceID, VolumeName,
@{
    Name       = 'Size(GB)';
    Expression = { [Math]::Round($_.Size / 1GB , 0) }
},
@{
    Name       = 'Free(GB)';
    Expression = { [Math]::Round($_.FreeSpace / 1GB , 0) }
},
@{
    Name       = 'Free';
    Expression = { "{0} %" -f ([Math]::Round($_.FreeSpace / $_.Size * 100 , 0)) }
} |
Format-Table -AutoSize

if ( -Not (Test-Path $ConsoleStartPath) ) {
    New-Item -Path $ConsoleStartPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
}
Set-Location -Path $ConsoleStartPath

$PSDefaultParameterValues = @{
    'Out-Default:OutVariable'      = 'LastResult'
    'Export-Csv:NoTypeInformation' = $true
}