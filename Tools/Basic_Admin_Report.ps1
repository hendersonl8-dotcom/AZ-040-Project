$computerName = $env:COMPUTERNAME
$system = Get-CimInstance -ClassName Win32_ComputerSystem
$system
Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Name, Manufacturer
Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Name, Manufacturer, Model, Domain
$system.Name
$system.Manufacturer
$system.Model
$system.Domain
$system | select-object Name, Manufacturer, Model, Domain | Format-Table -AutoSize
$system | get-member -MemberType Property
$system.NumberOfLogicalProcessors
$computerReport = $system | Select-Object Name, Manufacturer, Model, Domain, NumberOfLogicalProcessors
$computerReport | Format-Table -AutoSize
$bios = Get-CimInstance -ClassName Win32_BIOS
$bios
$bios.Manufacturer
$bios.SMBIOSBIOSVersion
$bios.SerialNumber
$biosreport = $bios | Select-Object Manufacturer, SMBIOSBIOSVersion, SerialNumber
$biosreport | Format-Table -AutoSize
$reportproerties = [PSCustomObject]@{
    ComputerName = $computerName
    Manufacturer = $system.Manufacturer
    Model = $system.Model
    Domain = $system.Domain
    NumberOfLogicalProcessors = $system.NumberOfLogicalProcessors
    BIOSManufacturer = $bios.Manufacturer
    BIOSVersion = $bios.SMBIOSBIOSVersion
    BIOSSerialNumber = $bios.SerialNumber
}
$reportproerties | Format-Table -AutoSize
$adminreport = [PSCustomObject]$reportproerties
$adminReport
$adminReport | Get-member -MemberType NoteProperty
$adminreport.ComputerName
$adminreport | select-object computername, Model, BiosVersion
$reportfolder = $env:USerProfile
$reportfolder
$adminReport | Export-Csv -Path "$reportfolder\adminreport.csv" -NoTypeInformation
Import-Csv -Path "$reportfolder\adminreport.csv" 
open-adminreport.csv
$adminreport.ComputerName
$adminreport.Domain
$bios | get-member -membertype property
$bios | select-object Manufacturer, SMBIOSBIOSVersion, SerialNumber,releaseDate, Version
$bios.ReleaseDate
BiosreleaseDate = $bios.ReleaseDate