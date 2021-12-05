# Load Variables

$proc = Get-Process -Name XXXXXXXXX
$con = Get-NetTCPConnection

#- Form Table
$Table =@()
ForEach($id in $proc.id){ 
                
                $file = Get-Process -Id $id -FileVersionInfo
                $Table += New-object -Type PSCustomObject -Property @{
                    PID     =   $id
                    HASH    =   (Get-FileHash -Path $file.FileName).hash
                    PATH    =   $file.filename   
                }
            }

        

    
    $Table 

$Filterdcon = $con | Where-Object{$Table.PID -contains $_.OwningProcess}   



$Filterdcon
