#process Alert System
#Simple Monitoring tool for CPU Load 
#Sends Top 10 Processes to you via mail


#-----------------------------Variables/Functions



$CPUask = Get-Process | Sort-Object CPU -descending
$CPUload = Get-WmiObject Win32_Processor | Select-Object LoadPercentage


#Customize me PLS
$Processout = "C:\tmp\ProcAlert Testin\procs.txt" #Choose your Folder Destination
$smtpserver= XXXXXXXX
$toaddress= XXXXXXXXXX
$message= XXXXXXXXX
$subject=hostname


#if Load high then 70% then send list with top Processes vvi mail
Function Start-ProcAlert
{
    While ($true)
    {
    
            if ($CPUload.LoadPercentage -gt 70) {
               # Write-Host "works"
                $CPUask | Select-Object -First 10 >> $Processout
                $message = new-object System.Net.Mail.MailMessage 
                $message.From = $fromaddress 
                $message.To.Add($toaddress)
                $message.IsBodyHtml = $True 
                $message.Subject = $subject "High CPU Load"
                $attach = new-object Net.Mail.Attachment($Processout) 
                $message.Attachments.Add($attach) 
                $smtp = new-object Net.Mail.SmtpClient($smtpserver) 
                $smtp.Send($message)
                Start-Sleep 60
            }
             
        
    }
}



#----------------------------Service







#Start the Service
Start-ProcAlert

