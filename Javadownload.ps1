Function Get-JavaURL {
    Param (
        $java,
        $JavaType
    )
    $linkGet = $java.links | Where-Object {$_.title -eq $javaType} | Select-Object -Property href
    $r = $linkGet[0] | Format-Wide -AutoSize | Out-String
    Return $r.trim()
}
Function Get-JavaBundleName {
    Param(
    $URL
    )
    $r = $URL.split("=")
    Return $r[1]
}
Function Get-JavaDownload {
    Param(
    $javaPath,
    $javaBit,
    $rootDir,
    $bit
    )
    if (!([System.IO.File]::Exists($javaPath))){
        Remove-Item "$rootDir\java$bit*"
        Move-item "$rootDir\Java Versions\java$bit*" -Destination "$rootDir\Java Versions\old"
        Invoke-WebRequest -uri $javaBit -OutFile $JavaPath
        $version = (get-item $JavaPath).VersionInfo.fileversion | Out-String
        $version = "java$bit." + $version.trim() + ".exe"
        
        Copy-Item $JavaPath "$rootDir\Java Versions\$version"
    }else{Write-Output "$javaPath already Exists!" }
}

#initial Variables
$java = (Invoke-WebRequest -uri https://java.com/en/download/manual.jsp)
$rootDir = "\\usblns-file2\itstore\SoftwareInstalls\Java\PSScript"

#Gets the URL for the Java Download from the website
$Java64Bit = Get-JavaURL -java $java -JavaType "Download Java software for windows (64-bit)"
$Java32Bit = Get-JavaURL -java $java -JavaType "Download Java software for windows Offline"

#Gets the Java Bundle name to be saved and compared to later
$java64Bundle = (Get-JavaBundleName -URL $Java64Bit)
$java32Bundle = (Get-JavaBundleName -URL $Java32Bit)

#sets the name of the file to be named after the bundle for comparison later
$Java32Path = "$rootDir\java32.$java32Bundle.exe"
$Java64Path = "$rootDir\java64.$java64Bundle.exe"

#Downloads Java
Get-JavaDownload -javaPath $Java32Path -javaBit $Java32Bit -rootDir $rootDir -bit "32"
Get-JavaDownload -javaPath $Java64Path -javaBit $Java64Bit -rootDir $rootDir -bit "64"




  
