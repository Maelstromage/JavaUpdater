#Gets Java versions with WMI
$javaVersions = Get-WmiObject -Class Win32_Product -Filter "Name like 'Java % Update %'" 
$JavaPath = "\\usblns-file2\ITStore\SoftwareInstalls\Java\PSScript\Java Versions"
$localPath = "c:\ITInstall"
$bit32 = ""
$bit64 = ""
$bit64Version = ""
$bit32Version = ""
$javaBit = ""
$upToDate64 = ""
$upToDate32 = ""

#check if 64 bit or 32
foreach($javaBit in $javaVersions) {
    
    if($javaBit.Name.Contains("(64-bit)")) {
        $bit64Version = $javaBit.version
        if([System.IO.File]::Exists("$JavaPath\Java64.$bit64Version.exe")){
            $upToDate64 = $true
            continue
        }
        $javaBit.Uninstall()
        $bit64 = $true
    }    
    if(!$javaBit.Name.Contains("(64-bit)")) {
        $bit32Version = $javaBit.version
        if([System.IO.File]::Exists("$JavaPath\Java32.$bit32Version.exe")){
            $upToDate32 = $true
            continue
        }
        $javaBit.Uninstall()
        $bit32 = $true
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





$bit64
$bit32
$bit32Version
$bit64Version



