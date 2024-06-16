## Using PSHTML to create great looking email reports
## Blog post with more information: https://jesspomfret.com/pshtml-email-reports

## Email details
# $emailTo = 'me@jesspomfret.com'
# $emailFrom = 'reports@jesspomfret.com'
# $emailSubject = ('Authors: {0}' -f (get-date -f yyyy-MM-dd))
# $smtpServer = 'smtp.server.address'

## Query details
$sqlInstance = 'mssql1'
$database = 'pubs '
$query = @"
SELECT TOP (10) [au_id]
      ,[au_lname]
      ,[au_fname]
      ,[phone]
      ,[address]
      ,[city]
      ,[state]
      ,[zip]
  FROM [dbo].[authors]
"@

$querySplat = @{
    SqlInstance     = $sqlInstance
    Database        = $database
    Query           = $query
    EnableException = $true
}
$results = Invoke-DbaQuery @querySplat

$dbs = Get-DbaDatabase -SqlInstance mssql1

# requirements
$backupWithinDays = 1 # databases should have full backups within this many days
$dbOwner = 'sa' # databases should have this owner
$dbStatus = 'ONLINE' # databases should be online

if ($results) {

    $reportCss = "
    table {
        border-collapse: collapse;
    }
    td, th {
        border: 1px solid #ddd;
        padding: 8px;
    }
    tr:nth-child(even){background-color: #f2f2f2;}
    tr:hover {background-color: #ddd;}
    th {
        padding-top: 12px;
        padding-bottom: 12px;
        text-align: left;
        background-color: #13a3a8;
        color: white;
    }
    .fail th {
        padding-top: 12px;
        padding-bottom: 12px;
        text-align: left;
        background-color: #ff6347;
        color: white;
    }
    "

    $html = html {
        head {
            style {
                $reportCss
            }
        }
        body {
            Header {
                h1 {"Morning Checks: {0}" -f (Get-Date -f 'yyyy-MM-dd')}
            }

            h2 {"Databases without Backups in the last $backupWithinDays days"}
            ConvertTo-PSHTMLTable -Object ($dbs | Where-Object LastFullBackup -le (get-date).AddDays(-$backupWithinDays) | Sort-Object name
            ) -properties SqlInstance, Name, LastFullBackup

            h2 {"Databases where owner isn't $dbOwner"}
            ConvertTo-PSHTMLTable -Object ($dbs | Where-Object Owner -ne $dbOwner | Sort-Object name
            ) -properties SqlInstance, Name, Owner

            h2 {"Databases where status isn't $dbStatus"}
            ConvertTo-PSHTMLTable -Object ($dbs | Where-Object Status -ne $dbStatus | Sort-Object name
            ) -properties SqlInstance, Name, Status, IsAccessible

        }
    }

    # You can output it as a html file to review how it looks
    $html > ./web/test.HTML

   # try {
   #     $emailSplat = @{
   #         To = $emailTo
   #         From = $emailFrom
   #         SmtpServer = $smtpServer
   #         Subject = $emailSubject
   #         Body = $html
   #         BodyAsHtml = $true
   #     }
   #     Send-MailMessage @emailSplat
   # } catch {
   #     Stop-PSFFunction -Message ('Failed to send email') -ErrorRecord $_
   # }
}