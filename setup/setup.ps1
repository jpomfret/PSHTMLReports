# clean up the web folder
Get-ChildItem web\* -Exclude pomfret.png | Remove-Item -ErrorAction SilentlyContinue

Import-Module PSHTML, dbatools

Set-DbatoolsInsecureConnection

$null = New-DbaDatabase -SqlInstance mssql1 -Name BrokenDb
$null = Set-DbaDbState -SqlInstance mssql1 -Database BrokenDb -Offline

cls