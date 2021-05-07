#process Alert System
#Simple Monitoring tool for CPU Load 
#Sends Top 10 Processes to you via mail


#-----------------------------Variables/Functions



$CPUask = Get-Process | Sort-Object WS -descending
$CPUload = Get-WmiObject win32_processor | Select-Object LoadPercentage


#Customize me PLS
$Processout = "C:\tmp\ProcAlert Testin\procs.txt" #Choose your Folder Destination
$smtpserver= XXXXXXXX
$toaddress= XXXXXXXXXX
$message= "High CPU Load"
$subject=hostname


#if Load higher then 70% send list with top Processes via mail
#function Get-CPU

Function Start-ProcAlert
{
    While ($true)
    {
            
                #CPU Load Testing
                if ($CPUload.LoadPercentage -gt 10) {
                Remove-Item $Processout
                $CPUask | Select-Object -First 10 >> $Processout
                #Write-Host "Works"

               #mailblock FIll ME
                $message = new-object System.Net.Mail.MailMessage 
                $message.From = $fromaddress 
                $message.To.Add($toaddress)
                $message.IsBodyHtml = $True 
                $message.Subject = $subject
                $attach = new-object Net.Mail.Attachment($Processout) 
                $message.Attachments.Add($attach) 
                $smtp = new-object Net.Mail.SmtpClient($smtpserver) 
                $smtp.Send($message)
                #Customize me
                Start-Sleep 120
            }
             
            
    }
}



#----------------------------Service

#Start the Service
Start-ProcAlert

#messin around

