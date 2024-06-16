# We have the ability to create HTML reports built-in to PowerShell
Get-Process | ConvertTo-Html | Out-File -Path ./web/processes.html

# But it's not beautiful...

# Enter a community module
Import-Module PSHTML

# Commands available
Get-Command -Module PSHTML

# Let's create a simple heading
h1 -Content 'Hi PSConfEU'

# We can also create a simple paragraph
p -Content 'This is a simple paragraph'

# Let's combine these and create a simple HTML page

# Create a new HTML page
$html = html {
    head {
        title 'My First PSHTML Page'
    }
    body {
        h1 -Content 'Hi PSConfEU'
        p -Content 'This is a simple paragraph'
    }
}
$html | Out-File -FilePath ./web/simplePage.html

# open, format, preview
