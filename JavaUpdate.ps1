
$java = (Invoke-WebRequest -uri https://java.com/en/download/manual.jsp)

$href64 = $java.links | Where-Object {$_.title -eq "Download Java software for windows (64-bit)"} | Select-Object -Property href
$Java64 = $href64[0] | Format-Wide -AutoSize | Out-String
$href32 = $java.links | Where-Object {$_.title -eq "Download Java software for windows Offline"} | Select-Object -Property href
$Java32 = $href32[0] | Format-Wide -AutoSize | Out-String 

Invoke-WebRequest -uri $java32 -OutFile C:"\java32.exe"
$version32 = (get-item c:\java.exe).VersionInfo.fileversion | Out-String
$version32 = "java" + $version32.trim() + ".exe"

Rename-Item c:\java.exe -NewName $version32
