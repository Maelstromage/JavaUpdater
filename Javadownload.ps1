Function Get-JavaURL {
    Param (
        $java,
        $JavaType
    )
    $linkGet = $java.links | Where-Object {$_.title -eq $javaType} | Select-Object -Property href
    $r = $linkGet[0] | Format-Wide -AutoSize | Out-String
    $r = $r.trim()
    Write-Output "Java URL Found:`r`n $r" >> $logFilePath
    Return $r
}
Function Get-JavaBundleName {
    Param($URL)
    $r = $URL.split("=")
    Write-Output "Java Bundle Name:`r`n $r" >> $logFilePath
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
        Remove-Item "$rootDir\java$bit*" -verbose
        Move-item "$rootDir\Java Versions\java$bit*" -Destination "$rootDir\Java Versions\old" -verbose
        Write-Output "New Java version found! Downloading file `r`n $javaPath" >> $logFilePath
        Invoke-WebRequest -uri $javaBit -OutFile $JavaPath
        $version = (get-item $JavaPath).VersionInfo.fileversion | Out-String
        $version = "java$bit." + $version.trim() + ".exe"
        Write-Output "Coping file to deployment folder `r`n $version" >> $logFilePath
        Copy-Item $JavaPath "$rootDir\Java Versions\$version" -verbose
    }else{Write-Output "File Exists. No Download. `r`n $javaPath" >> $logFilePath}
}
#initial Variables
$java = (Invoke-WebRequest -uri https://java.com/en/download/manual.jsp)
$rootDir = "\\usblns-file2\itstore\SoftwareInstalls\Java\PSScript"
$logFilePath = "$PSScriptRoot\log.txt"

#creates SSL connection
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 

#Checks to see if the log file exists and if it does deletes all but the last 2000 lines
if (([System.IO.File]::Exists($logFilePath))){
    Get-Content $logFilePath | Select-Object -Last 2000 | Set-Content $logFilePath -Encoding Unicode
}

#adds the date to the log file
get-date | Write-Output >> $logFilePath

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




  
