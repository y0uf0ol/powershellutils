#NCT Network change Tracker
#Compares two Scans and writes out the changes nad sends them via mail

##-------------------VARIABLES-------------------------------
$FileOut = ".\Scan.csv"
$FileOutold = ".\ScanOLD.csv"
$outputfile = ".\ScanDiff.csv"
$Subnet = "XXX.XXX.XXX.XXX"
$fromaddress = "XXX@yyy.com" 
$toaddress = "XXX@yyy.com" 
$DIFFSubject = "Diff in Network found" 
$OKSubject = "Everything OK" 
$body = "Diff Found"
$attachment = $outputfile 
$smtpserver = "xxxx" 


#if file exists
if(Test-Path $FileOut -PathType Leaf){
    Remove-Item $FileOutold
    Rename-Item $FileOut $FileOutold

}else {
    Write-Host 'Initial Scan is missing'
    Write-Host 'Start initial Scan now'

    #Scan
    1..254|ForEach-Object{
        Start-Process -WindowStyle Hidden ping.exe -Argumentlist "-n 1 -l 0 -f -i 2 -w 1 -4 $SubNet$_"
    }
    $Computers =(arp.exe -a | Select-String "$SubNet.*dynam") -replace ' +',','|
      ConvertFrom-Csv -Header Computername,IPv4,MAC,x,Vendor|
                       Select-Object Computername,IPv4,MAC
    ForEach ($Computer in $Computers){
      nslookup $Computer.IPv4|Select-String -Pattern "^Name:\s+([^\.]+).*$"|
        ForEach-Object{
          $Computer.Computername = $_.Matches.Groups[1].Value
        }
    }
    $Computers
    $Computers | Export-Csv $FileOut -NotypeInformation
    exit
}

#Scan
1..254|ForEach-Object{
    Start-Process -WindowStyle Hidden ping.exe -Argumentlist "-n 1 -l 0 -f -i 2 -w 1 -4 $SubNet$_"
}
$Computers =(arp.exe -a | Select-String "$SubNet.*dynam") -replace ' +',','|
  ConvertFrom-Csv -Header Computername,IPv4,MAC,x,Vendor|
                   Select-Object Computername,IPv4,MAC
ForEach ($Computer in $Computers){
  nslookup $Computer.IPv4|Select-String -Pattern "^Name:\s+([^\.]+).*$"|
    ForEach-Object{
      $Computer.Computername = $_.Matches.Groups[1].Value
    }
}
$Computers
$Computers | Export-Csv $FileOut -NotypeInformation



#check Diff
Compare-Object -ReferenceObject (Get-Content $FileOut) -DifferenceObject (Get-Content $FileOutold) > $outputfile


##----------------------------Relay-----------------------

if((Get-Content $outputfile) -eq $Null){
    #OK Message
    Write-Host 'Everything is fine'
    $message = new-object System.Net.Mail.MailMessage 
    $message.From = $fromaddress 
    $message.To.Add($toaddress)
    $message.IsBodyHtml = $True 
    $message.Subject = $OKSubject
    $attach = new-object Net.Mail.Attachment($attachment) 
    $message.Attachments.Add($attach) 
    $smtp = new-object Net.Mail.SmtpClient($smtpserver) 
    $smtp.Send($message)
    Exit


}else {
    $message = new-object System.Net.Mail.MailMessage 
    $message.From = $fromaddress 
    $message.To.Add($toaddress)
    $message.IsBodyHtml = $True 
    $message.Subject = $DiffSubject 
    $attach = new-object Net.Mail.Attachment($attachment) 
    $message.Attachments.Add($attach) 
    $message.body = $body 
    $smtp = new-object Net.Mail.SmtpClient($smtpserver) 
    $smtp.Send($message)
}
