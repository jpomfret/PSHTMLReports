# clean up the web folder
Get-ChildItem web\* | Remove-Item -ErrorAction SilentlyContinue
