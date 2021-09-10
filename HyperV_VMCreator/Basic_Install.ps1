#---- VM creator



#Get-Values
$VMName=Read-Host "Enter VM Name"
$ISOPath=Read-Host "Path to ISO"
$CPU=Read-Host "Enter Processor Count"
#Read and convert VHD
$messageVHD = "Enter VHD Size in GB (or specify unit)"
do
{
    [int64]$Size=$null
    [string]$SSize=Read-Host $messageVHD
    switch -regex ($SSize)
    {
        '^\d+KB$' { $Size = 1KB * $SSize.Substring(0,$SSize.Length-2) }
        '^\d+MB$' {$Size= 1MB * $SSize.Substring(0,$SSize.Length-2) }
        '^\d+GB$' { $Size = 1GB * $SSize.Substring(0,$SSize.Length-2) }
        '\D+' {Write-Verbose 'No valid integer entered'} #no number means $null 
        '^\d+$' {$Size = 1GB * $SSize}
        default {$Size = 1 * 1GB} #no entry = 1GB
    }
    $messageVHD = "Invalid Entry, please enter RAM amount in GB (or specify unit)"
}
until ($Size) 
$Size


#Read and convert RAM
$messageRAM = "Enter RAM amount in GB (or specify unit)"
do
{
    [int64]$RAM=$null
    [string]$SRAM=Read-Host $messageRAM
    switch -regex ($SRAM)
    {
        '^\d+KB$' { $RAM = 1KB * $SRAM.Substring(0,$SRAM.Length-2) }
        '^\d+MB$' {$RAM = 1MB * $SRAM.Substring(0,$SRAM.Length-2) }
        '^\d+GB$' { $RAM = 1GB * $SRAM.Substring(0,$SRAM.Length-2) }
        '\D+' {Write-Verbose 'No valid integer entered'} #no number means $null 
        '^\d+$' {$RAM = 1GB * $SRAM}
        default {$RAM = 1 * 1GB} #no entry = 1GB
    }
    $messageRAM = "Invalid Entry, please enter RAM amount in GB (or specify unit)"
}
until ($RAM) 
$RAM

#Variables needs to be changed 
$VmFolder="C:\VM\$VMName"
$VMVHD="$VmFolder\VHD\$VMName.vhdx"

#Create the VM
New-VM -Name $VMName -Generation 2 -BootDevice VHD -Path $VmFolder -MemoryStartupBytes $RAM -NewVHDPath $VMVHD -NewVHDSizeBytes $Size
Set-VM -Name $VMName -ProcessorCount $CPU -DynamicMemory -MemoryMaximumBytes $RAM

#Add VM ISO
Add-VMDvdDrive -VMName $VMName
Set-VMDvdDrive -VMName $VMName -Path $ISOPath

Set-VMFirmware -VmName $VMName -FirstBootDevice (Get-VMDvdDrive -VMName $VMName)
