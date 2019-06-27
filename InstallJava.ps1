#Gets Java versions with WMI
$javaVersions = Get-WmiObject -Class Win32_Product -Filter "Name like 'Java % Update %'" 
$JavaPath = "\\usblns-file2\ITStore\SoftwareInstalls\Java\PSScript\Java Versions"
$localPath = "c:\ITInstall"
$upToDate64 = $null
$upToDate32 = $null

$bit64Version = ""
$bit32Version = ""
$javaBit = ""



#check if ITInstall folder exists and makes it if not
if(![System.IO.File]::Exists($localPath)){
    New-Item -ItemType "directory" -Path $localPath
    Write-output "$localPath does not exist, creating folder" >> "$localPath\log.txt"
}

#timestamps log file
Write-Output (Get-Date) >> "$localPath\log.txt"

#check if 64 bit or 32
foreach($javaBit in $javaVersions) {
    
    if($javaBit.Name.Contains("(64-bit)")) {
        $bit64Version = $javaBit.version
        Write-Output "Java Version Found: $bit64Version" >> "$localPath\log.txt"
        if([System.IO.File]::Exists("$JavaPath\Java64.$bit64Version.exe")){
            $upToDate64 = $true
            Write-Output "Java version is up to date: Java.$bit64Version. Keeping this version." >> "$localPath\log.txt"
            continue
        }elseif($upToDate64 -eq $null){$upToDate64 = $false}
        Write-Output "Uninstalling Java.$bit64Version" >> "$localPath\log.txt"
        $javaBit.Uninstall() >> "$localPath\log.txt"
        
    }    
    if(!$javaBit.Name.Contains("Offline")) {
        $bit32Version = $javaBit.version
        Write-Output "Java Version Found: $bit32Version" >> "$localPath\log.txt"
        if([System.IO.File]::Exists("$JavaPath\Java32.$bit32Version.exe")){
            $upToDate32 = $true
            Write-Output "Java version is up to date: Java.$bit32Version. Keeping this version." >> "$localPath\log.txt"
            continue
        }elseif($upToDate32 -eq $null){$upToDate32 = $false}
        Write-Output "Uninstalling Java.$bit32Version" >> "$localPath\log.txt"
        $javaBit.Uninstall() >> "$localPath\log.txt"
       
    }

}
if($upToDate64 -eq $false){
    Remove-Item "$localPath\java64*.exe" -Verbose  >> "$localPath\log.txt"
    Copy-Item "$javaPath\java64*.exe" "$localPath\" -Verbose  >> "$localPath\log.txt"
    Write-Output "Installing Java64" >> "$localPath\log.txt"
    Start-Process (Get-ChildItem "$localPath\Java64*.exe") -ArgumentList /s -wait 
    
}
if($upToDate32 -eq $false){
    Remove-Item "$localPath\java32*.exe" -Verbose  >> "$localPath\log.txt"
    Copy-Item "$javaPath\java32*.exe" "$localPath\" -Verbose  >> "$localPath\log.txt"
    Write-Output "Installing Java32" >> "$localPath\log.txt"
    Start-Process (Get-ChildItem "$localPath\Java32*.exe") -ArgumentList /s -wait 
}




