# we can also use PSHTML to easily create tables

# I wrote '$data =' ... copilot did the rest and is 100% correct
$data = @(
    [PSCustomObject]@{
        Name = 'Jess'
        Age = 30
        Location = 'UK'
    }
    [PSCustomObject]@{
        Name = 'Rob'
        Age = 31
        Location = 'UK'
    }
    [PSCustomObject]@{
        Name = 'Chrissy'
        Age = 29
        Location = 'UK'
    }
)

ConvertTo-PSHTMLTable -Object $data | Out-File ./web/table.html

# open, format, preview

# but it's still not really beautiful - add some CSS
# but I don't know CSS, and I have no style... - https://divtable.com/table-styler/
$css = @"
table.paleBlueRows {
  font-family: "Times New Roman", Times, serif;
  border: 1px solid #FFFFFF;
  width: 350px;
  height: 200px;
  text-align: center;
  border-collapse: collapse;
}
table.paleBlueRows td, table.paleBlueRows th {
  border: 1px solid #FFFFFF;
  padding: 3px 2px;
}
table.paleBlueRows tbody td {
  font-size: 13px;
}
table.paleBlueRows tr:nth-child(even) {
  background: #D0E4F5;
}
table.paleBlueRows thead {
  background: #0B6FA4;
  border-bottom: 5px solid #FFFFFF;
}
table.paleBlueRows thead th {
  font-size: 17px;
  font-weight: bold;
  color: #FFFFFF;
  text-align: center;
  border-left: 2px solid #FFFFFF;
}
table.paleBlueRows thead th:first-child {
  border-left: none;
}

table.paleBlueRows tfoot {
  font-size: 14px;
  font-weight: bold;
  color: #333333;
  background: #D0E4F5;
  border-top: 3px solid #444444;
}
table.paleBlueRows tfoot td {
  font-size: 14px;
}
"@

$html = html {
    head {
        style {
            $css
            }
        }
    body {
      h1 {"Beautiful Table Report: {0}" -f (Get-Date -f 'yyyy-MM-dd')}
      ConvertTo-PSHTMLTable -Object $data -TableClass paleBlueRows
    }
}
$html | Out-File .\web\table.html

# and you can get data from anywhere - any PSObject

## HAHA dbatools makes it into my session!

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

# view the results:

$results

# lets edit our html from before

$html = html {
  head {
      style {
          $css
          }
      }
  body {
      h1 {"Beautiful Table Report: {0}" -f (Get-Date -f 'yyyy-MM-dd')}}
      h2 {"Data from CoPilot's PSObject"}
      ConvertTo-PSHTMLTable -Object $data -TableClass paleBlueRows

      h2 {"Data from SQL Server"}
      ConvertTo-PSHTMLTable -Object $results -TableClass paleBlueRows
}
$html | Out-File .\web\table.html
