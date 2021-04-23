
###############     TEAMS AUTO LOADER    ###############
## Author: Y0of0ol
## Creation 28.3.2021
## ToDo: Automatic webfetch der Teamsinstall dateii



#Variables
$url="https://go.microsoft.com/fwlink/p/?LinkID=869426&clcid=0x407&culture=de-de&country=DE&lm=deeplink&lmsrc=groupChatMarketingPageWeb&cmpid=directDownloadWin64"
$download="C:\tmp\"             #Anpassen nicht vergessen
$Archiv="C:\tmp\Archiv"         #Anpassen nicht vergessen
$installer="teamsinstaller.exe"
$oginstaller="teams.exe"
$Date= Get-Date -Format "MM/dd/yyyy"
$ogarchiv="$oginstaller.$Date.exe"

#directory change
    Set-Location $download
#Download
    wget $url -outfile $installer
#wait till download finished
    Start-Sleep -Seconds 1
#Define Signature
    $Signature= Get-AuthenticodeSignature $installer 
# Valid Check
    if ($Signature.Status -eq 'Valid') {
        Rename-item $oginstaller "$oginstaller.$Date.exe"
        Move-Item $ogarchiv $Archiv
        Rename-Item $installer $oginstaller
        Exit-PSSession

    }
    else {
         Remove-Item $installer
         echo INVALID SIGNATURE > "INVALID SIGNATURE.txt"
         Exit-PSSession
    }

  