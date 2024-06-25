## Using PSHTML to create great looking email reports
## Blog post with more information: https://jesspomfret.com/pshtml-email-reports

## Email details
# $emailTo = 'me@jesspomfret.com'
# $emailFrom = 'reports@jesspomfret.com'
# $emailSubject = ('Authors: {0}' -f (get-date -f yyyy-MM-dd))
# $smtpServer = 'smtp.server.address'

# get the database information with dbatools
$dbs = Get-DbaDatabase -SqlInstance mssql1
$dbs

# requirements
$backupWithinDays = 1 # databases should have full backups within this many days
$dbOwner = 'sa' # databases should have this owner
$dbStatus = 'Normal' # databases should be online

$pieCanvasID      = "pieCanvas"
$doughnutCanvasID = "doughnutCanvas"
$barCanvasID      = "barCanvas"

$html = html {
    head {
        script -src "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.3/Chart.min.js" -type "text/javascript"

        # add bootstrap for some basic styling
        # bootstrap is a free and open-source CSS framework directed at responsive, mobile-first front-end web development.
        link -href "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" -rel "stylesheet"
        script -src "https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js" -type "text/javascript"
        script -src "https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js" -type "text/javascript"

    }
    body {
        Header {
            h1 {"Morning Checks: {0}" -f (Get-Date -f 'yyyy-MM-dd HH:mm:ss')}
        }

        #region Charts

        div -class "container-fluid" {
            div -class "row" {
                div -class "col-sm-4" {
                    canvas -Height 300px -Width 300px -Id $pieCanvasID {}
                }
                div -class "col-sm-4" {
                    canvas -Height 300px -Width 300px -Id $BarCanvasID {}
                }
                div -class "col-sm-4" {
                    canvas -Height 300px -Width 300px -Id $DoughnutCanvasID {}
                }
            }
        }

        script -content {

            $data   = $dbs | Group-Object Compatibility
            $counts = $data | ForEach-Object {$_.Count}
            $labels = $data.Name
            $colours = @("yellow","red","green","orange","blue")

            $dsp1   = New-PSHTMLChartPieDataSet -Data $counts -BackgroundColor $colours
            New-PSHTMLChart -type pie -DataSet $dsp1 -title "Count of database compatibility levels" -Labels $labels -CanvasID pieCanvas

            $barcounts = $dbs.SizeMB
            $barlabels = $dbs.Name

            $dsb1 = New-PSHTMLChartBarDataSet -Data $barcounts -label "Size (MB)" -backgroundColor 'blue' -hoverBackgroundColor 'red' -borderColor 'red' -hoverBorderColor 'red'
            New-PSHTMLChart -type bar -DataSet $dsb1 -title "Database Size in MB" -Labels $barlabels -CanvasID $BarCanvasID

            $docounts = $dbs | Group-Object status | ForEach-Object {$_.Count}
            $dolabels = $dbs.status | Select-Object -Unique

            $colours = @("green","red","yellow","orange","blue")
            $dsd1 = New-PSHTMLChartDoughnutDataSet -Data $docounts -backgroundcolor $colours -hoverbackgroundColor $colours
            New-PSHTMLChart -Type doughnut -DataSet $dsd1 -title "Database Status" -Labels $dolabels -CanvasID $DoughnutCanvasID

        }

        #endregion

        #region tables
        h2 {"Databases without Backups in the last $backupWithinDays days"}
        if  ($dbs | Where-Object LastFullBackup -le (get-date).AddDays(-$backupWithinDays)) {
            ConvertTo-PSHTMLTable -Object ($dbs | Where-Object LastFullBackup -le (get-date).AddDays(-$backupWithinDays) | Sort-Object name
            ) -properties SqlInstance, Name, LastFullBackup -TableClass 'table table-striped'
        } else {
            p {"All databases have been backed up in the last $backupWithinDays days"}
        }

        h2 {"Databases where owner isn't $dbOwner"}
        if ($dbs | Where-Object Owner -ne $dbOwner) {
            ConvertTo-PSHTMLTable -Object ($dbs | Where-Object Owner -ne $dbOwner | Sort-Object name
            ) -properties SqlInstance, Name, Owner -TableClass 'table table-striped'
        } else {
            p {"All databases are owned by $dbOwner"}
        }

        h2 {"Databases where status isn't $dbStatus"}
        if ($dbs | Where-Object Status -ne $dbStatus) {
            ConvertTo-PSHTMLTable -Object ($dbs | Where-Object Status -ne $dbStatus | Sort-Object name
            ) -properties SqlInstance, Name, Status, IsAccessible -TableClass 'table table-striped'
        } else {
            p {"All databases are online"}
        }
        #endregion
    }
}
# You can output it as a html file to review how it looks
$html > ./web/MorningChecksReport.HTML

# Fix BrokenDb
Set-DbaDbState -SqlInstance mssql1 -Database BrokenDb -Online

# rerun report...

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
