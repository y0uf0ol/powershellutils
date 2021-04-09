###############     Downloadassistant    ###############
## Author: y0uf0ol
## Creation 08.4.2021
## ToDo: 
        #Virusttotal Api anbindung
        #GUI überarbeiten
        #Auto Clipboard übernahmen in textfeld
        #Backend für Hash Validierung
        #Delete File and Open Folder Button
        #Pfad angaben

#--------------------------------------------[Variables]-------------------------------------------------
$dwpath="c:\Users\uwall\Downloads"

#--------------------------------------------[INIT]-------------------------------------------------
# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#--------------------------------------------[FORM]-------------------------------------------------
# Create a new form
[System.Windows.Forms.Application]::EnableVisualStyles()

$DAWform                            = New-Object system.Windows.Forms.Form
$DAWform.ClientSize                 = '800,600'
$DAWform.text                       = "Download Assistant"
$DAWform.BackColor                  = "#ffffff"
$DAWform.TopMost                    = $false

$Titel                              = New-Object system.Windows.Forms.Label
$Titel.text                         = "Gimma your Links"
$Titel.AutoSize                     = $true
$Titel.width                        = 25
$Titel.height                       = 10
$Titel.location                     = New-Object System.Drawing.Point(20,20)
$Titel.Font                         = 'Microsoft Sans Serif,13'

$Description                        = New-Object system.Windows.Forms.Label
$Description.text                   = 'Enter Download Link and the Filename of the Output'
$Description.AutoSize               = $false
$Description.width                  = 450
$Description.height                 = 50
$Description.location               = New-Object System.Drawing.Point(20,50)
$Description.Font                   = 'Microsoft Sans Serif,10'

$DALinkLabel                        = New-Object system.Windows.Forms.Label
$DALinkLabel.text                   = "Link:"
$DALinkLabel.AutoSize               = $true
$DALinkLabel.width                  = 25
$DALinkLabel.height                 = 10
$DALinkLabel.location               = New-Object System.Drawing.Point(20,115)
$DALinkLabel.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$DANameLabel                        = New-Object system.Windows.Forms.Label
$DANameLabel.text                   = "Name:"
$DANameLabel.AutoSize               = $true
$DANameLabel.width                  = 25
$DANameLabel.height                 = 10
$DANameLabel.location               = New-Object System.Drawing.Point(20,145)
$DANameLabel.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$DAHashLabel                        = New-Object system.Windows.Forms.Label
$DAHashLabel.text                   = "SHA1:"
$DAHashLabel.AutoSize               = $true
$DAHashLabel.width                  = 25
$DAHashLabel.height                 = 10
$DAHashLabel.location               = New-Object System.Drawing.Point(20,175)
$DAHashLabel.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$DAHashLabel2                        = New-Object system.Windows.Forms.Label
$DAHashLabel2.text                   = "SHA256:"
$DAHashLabel2.AutoSize               = $true
$DAHashLabel2.width                  = 25
$DAHashLabel2.height                 = 10
$DAHashLabel2.location               = New-Object System.Drawing.Point(20,205)
$DAHashLabel2.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$DAHashLabel3                        = New-Object system.Windows.Forms.Label
$DAHashLabel3.text                   = "MD5:"
$DAHashLabel3.AutoSize               = $true
$DAHashLabel3.width                  = 25
$DAHashLabel3.height                 = 10
$DAHashLabel3.location               = New-Object System.Drawing.Point(20,235)
$DAHashLabel3.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$DAHashLabel4                        = New-Object system.Windows.Forms.Label
$DAHashLabel4.text                   = "Signature:"
$DAHashLabel4.AutoSize               = $true
$DAHashLabel4.width                  = 25
$DAHashLabel4.height                 = 10
$DAHashLabel4.location               = New-Object System.Drawing.Point(20,265)
$DAHashLabel4.Font                   = 'Microsoft Sans Serif,10,style=Bold'

#Link Input
$DALink                             = New-Object System.Windows.Forms.TextBox
$DALink.AutoSize                    = $true
$DALink.width                       = 300
$DALink.height                      = 20
$DALink.location                    = New-Object System.Drawing.Point(100,115)

#Name of Download
$DAName                             = New-Object System.Windows.Forms.TextBox
$DAName.AutoSize                    = $true
$DAName.width                       = 300
$DAName.height                      = 20
$DAName.location                    = New-Object System.Drawing.Point(100,145)

#Sha1 Output
$DASha1                            = New-Object System.Windows.Forms.TextBox
$DASha1.AutoSize                   = $true
$DASha1.width                      = 500
$DASha1.height                     = 20
$DASha1.location                   = New-Object System.Drawing.Point(100,175)

#sha256 Output
$DASha256                            = New-Object System.Windows.Forms.TextBox
$DASha256.AutoSize                   = $true
$DASha256.width                      = 500
$DASha256.height                     = 20
$DASha256.location                   = New-Object System.Drawing.Point(100,205)

#MD5 Output
$DAMD5                            = New-Object System.Windows.Forms.TextBox
$DAMD5.AutoSize                   = $true
$DAMD5.width                      = 500
$DAMD5.height                     = 20
$DAMD5.location                   = New-Object System.Drawing.Point(100,235)

#Signature Output
$DASignature                            = New-Object System.Windows.Forms.TextBox
$DASignature.AutoSize                   = $true
$DASignature.width                      = 500
$DASignature.height                     = 20
$DASignature.location                   = New-Object System.Drawing.Point(100,265)

#--------------------------------------------[Button/Functions]-------------------------------------------------

#Download Button
$downloadBtn                          = New-Object system.Windows.Forms.Button
$downloadBtn.BackColor                = "#ffffff"
$downloadBtn.text                     = "Download"
$downloadBtn.width                    = 90
$downloadBtn.height                   = 30
$downloadBtn.location                 = New-Object System.Drawing.Point(260,300)
$downloadBtn.Font                     = 'Microsoft Sans Serif,10'
$downloadBtn.ForeColor                = "#000"
$downloadBtn.Add_Click({
    #Define Link Input as Variable
    #$DaLink.text=Get-Clipboard
    $DaLinkgrep=$DaLink.Text

    #Define Output Name
    $DownloadName=$DAName.Text
    #Download File 
    Invoke-WebRequest $DaLinkgrep -OutFile $DownloadName 
    Start-Sleep -Seconds 1
    #Get Hashes and Signature and write out
    Get-FileHash -Algorithm SHA1 $DownloadName > "$DownloadName.Hash.txt"
    Get-FileHash -Algorithm SHA256 $DownloadName >> "$DownloadName.Hash.txt"
    Get-FileHash -Algorithm MD5 $DownloadName >> "$DownloadName.Hash.txt"
    Get-AuthenticodeSignature $DownloadName >> "$DownloadName.Hash.txt"
    #Show Hashes in Form
    $DASha1hash=Get-FileHash -Algorithm SHA1 $DownloadName | Format-List Hash | out-string
    $DASha256hash=Get-FileHash -Algorithm SHA256 $DownloadName | Format-List Hash | out-string
    $DAMD5hash=Get-FileHash -Algorithm MD5 $DownloadName | Format-List Hash | out-string
    $DASignaturesig=Get-AuthenticodeSignature $DownloadName | Format-List Status | Out-String
    #Format Output
    $DASha1.Text=$DASha1hash.substring(($DASha1hash.indexof(":")+1))
    $DASha256.Text=$DASha256hash.substring(($DASha256hash.indexof(":")+1))
    $DAMD5.Text=$DAMD5hash.substring(($DAMD5hash.indexof(":")+1))
    $DASignature.Text=$DASignaturesig.substring(($DASignaturesig.indexof(":")+1))
  
        
    })

#Delete Button
$deleteBtn                          = New-Object system.Windows.Forms.Button
$deleteBtn.BackColor                = "#ffffff"
$deleteBtn.text                     = "Delte File"
$deleteBtn.width                    = 90
$deleteBtn.height                   = 30
$deleteBtn.location                 = New-Object System.Drawing.Point(600,300)
$deleteBtn.Font                     = 'Microsoft Sans Serif,10'
$deleteBtn.ForeColor                = "#000"
$downloadBtn.Add_Click({
      Remove-Item  $DownloadName

    })
#Cancel Button
$cancelBtn                          = New-Object system.Windows.Forms.Button
$cancelBtn.BackColor                = "#ffffff"
$cancelBtn.text                     = "Close"
$cancelBtn.width                    = 90
$cancelBtn.height                   = 30
$cancelBtn.location                 = New-Object System.Drawing.Point(400,300)
$cancelBtn.Font                     = 'Microsoft Sans Serif,10'
$cancelBtn.ForeColor                = "#000"
$cancelBtn.DialogResult             = [System.Windows.Forms.DialogResult]::Cancel
$DAWform.CancelButton               = $cancelBtn
$DAWform.Controls.Add($cancelBtn)

$DAWform.controls.AddRange(@($Titel,$Description,$DALinkLabel,$DAHashLabel2,$DAHashLabel3,$DAHashLabel4,$DAName,$DASha1,$DASha256,$DAMD5,$DAHashLabel,$DASignature,$DANameLabel,$DALink,$downloadBtn,$deleteBtn,$cancelBtn))





#'https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe'




# Display the form
[void]$DAWform.ShowDialog()


