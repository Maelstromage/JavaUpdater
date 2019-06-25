#Gets Java versions with WMI
$javaVersions = Get-WmiObject -Class Win32_Product -Filter "Name like 'Java % Update %'" 
$JavaPath = "\\usblns-file2\ITStore\SoftwareInstalls\Java\PSScript\Java Versions"
$localPath = "c:\ITInstall"
$upToDate64 = $false
$upToDate32 = $false

$bit64Version = ""
$bit32Version = ""
$javaBit = ""


#check if 64 bit or 32
foreach($javaBit in $javaVersions) {
    
    if($javaBit.Name.Contains("(64-bit)")) {
        $bit64Version = $javaBit.version
        if([System.IO.File]::Exists("$JavaPath\Java64.$bit64Version.exe")){
            $upToDate64 = $true
            continue
        }
        $javaBit.Uninstall()
        
    }    
    if(!$javaBit.Name.Contains("(64-bit)")) {
        $bit32Version = $javaBit.version
        if([System.IO.File]::Exists("$JavaPath\Java32.$bit32Version.exe")){
            $upToDate32 = $true
            continue
        }
        $javaBit.Uninstall()
       
    }

}
if(!$upToDate64){
    Remove-Item "$localPath\java64*.exe"
    Copy-Item "$javaPath\java64*.exe" "$localPath\"
    Start-Process (Get-ChildItem "$localPath\Java64*.exe") -ArgumentList /s -wait
    
}
if(!$upToDate32){
    Remove-Item "$localPath\java32*.exe"
    Copy-Item "$javaPath\java32*.exe" "$localPath\"
    Start-Process (Get-ChildItem "$localPath\Java32*.exe") -ArgumentList /s -wait
}




