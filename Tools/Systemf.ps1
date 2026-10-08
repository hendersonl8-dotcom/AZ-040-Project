$computer = "LON-SVR1"
$os = Get-CimInstance -classname Win32_OperatingSystem -ComputerName $computer
$os.Caption
$os.LocalDateTime
$os.LastBootUpTime

$cDrive = Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $computer -Filter "DeviceID='C:'"
$cDrive.DeviceID
$cDrive.Size
$cdrive.FreeSpace
[math]::Round($cDrive.Size / 1GB, 2)
[math]::Round($cDrive.FreeSpace / 1GB, 2)
$uptime = $os.LocalDateTime - $os.LastBootUpTime
$uptime.Days
$uptime.TotalHours
[math]::Round($uptime.TotalHours, 2)

$info = [PSCustomObject]@{
    Name = $computer
    OS = $os.Caption
    LocalTime = $os.LocalDateTime
    LastBootUpTime = $os.LastBootUpTime
    CDriveDeviceID = $cDrive.DeviceID
    CDriveSize = [math]::Round($cDrive.Size / 1GB, 2)
    CDriveFreeSpace = [math]::Round($cDrive.FreeSpace / 1GB, 2)
    UptimeDays = $uptime.Days
    UptimeHours = [math]::Round($uptime.TotalHours, 2)
}
$info | Format-Table -AutoSize
get-member -InputObject $info

Write-Output $info
