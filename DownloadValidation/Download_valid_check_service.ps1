###############     Downloadassistant    ###############
## Author: y0uf0ol
## Creation 08.4.2021
## ToDo: 
#--------------------------------------------[Variables]-------------------------------------------------


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
$Description.text                   = 'Give me a Link and i give you a Hash'
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

#$DAHashLabel                        = New-Object system.Windows.Forms.Label
#$DAHashLabel.text                   = "Hash:"
#$DAHashLabel.AutoSize               = $true
#$DAHashLabel.width                  = 25
#$DAHashLabel.height                 = 10
#$DAHashLabel.location               = New-Object System.Drawing.Point(20,165)
#$DAHashLabel.Font                   = 'Microsoft Sans Serif,10,style=Bold'

#Link Input
$DALink                             = New-Object System.Windows.Forms.TextBox
$DALink.AutoSize                    = $true
$DALink.width                       = 300
$DALink.height                      = 20
$DALink.location                    = New-Object System.Drawing.Point(100,115)

#Hash Output
#$DAHash                            = New-Object System.Windows.Forms.TextBox
#$DAHash.AutoSize                   = $true
#$DAHash.width                      = 300
#$DAHash.height                     = 20
#$DAHash.location                   = New-Object System.Drawing.Point(100,165)

#Download Button
$downloadBtn                          = New-Object system.Windows.Forms.Button
$downloadBtn.BackColor                = "#ffffff"
$downloadBtn.text                     = "Download"
$downloadBtn.width                    = 90
$downloadBtn.height                   = 30
$downloadBtn.location                 = New-Object System.Drawing.Point(260,250)
$downloadBtn.Font                     = 'Microsoft Sans Serif,10'
$downloadBtn.ForeColor                = "#000"
$downloadBtn.Add_Click({
    #Define Link Input as Variable
    $DaLinkgrep=$DALink.Text
    Invoke-WebRequest $DaLinkgrep -OutFile "yolo.exe" 

  })

  #"https://go.microsoft.com/fwlink/p/?LinkID=869426&clcid=0x409&culture=en-us&country=US&lm=deeplink&lmsrc=groupChatMarketingPageWeb&cmpid=directDownloadWin64"
#Cancel Button
$cancelBtn                          = New-Object system.Windows.Forms.Button
$cancelBtn.BackColor                = "#ffffff"
$cancelBtn.text                     = "Cancel"
$cancelBtn.width                    = 90
$cancelBtn.height                   = 30
$cancelBtn.location                 = New-Object System.Drawing.Point(400,250)
$cancelBtn.Font                     = 'Microsoft Sans Serif,10'
$cancelBtn.ForeColor                = "#000"
$cancelBtn.DialogResult             = [System.Windows.Forms.DialogResult]::Cancel
$DAWform.CancelButton               = $cancelBtn
$DAWform.Controls.Add($cancelBtn)

$DAWform.controls.AddRange(@($Titel,$Description,$DALinkLabel,$DALink,$downloadBtn,$cancelBtn))










# Display the form
[void]$DAWform.ShowDialog()