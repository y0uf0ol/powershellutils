#List all Files and get the Size of them
#----------Variables

$Dir = Set-location -Path C:\ #Set your Directory
$log = "C:\Log.txt" #Set your Directory


#--------Functions

$Files= Get-childitem -Path $Dir 

#Write output of every File in $Dir
$output = foreach ($File in $Files)
    {Write-Output $File
    Write-Output((Get-Item $file).length/1MB) 
    Get-FileHash $File -Algorithm SHA1
    
    }  
    
    #Writes output of the loop
    Write-Output "Size in MB" | Out-File $log
    $output | Out-File $Log -Append
