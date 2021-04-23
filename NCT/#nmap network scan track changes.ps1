#nmap network scan track changes

##-------------------VARIABLES-------------------------------
$oldscan="oLDSCAN.xml"
$newscan="NEWSCAN.xml"
$subnet="192.168.0.0/24"
$outputfile="Diff.txt"

Remove-Item $oldscan
Rename-Item $newscan $oldscan
nmap.exe -sn -oX $newscan $subnet  

Compare-Object -ReferenceObject (Get-Content $newscan) -DifferenceObject (Get-Content $oldscan) > $outputfile


##----------------------------Relay-----------------------


