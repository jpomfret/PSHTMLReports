# clean up the web folder
Get-ChildItem web\* -Exclude pomfret.png | Remove-Item -ErrorAction SilentlyContinue