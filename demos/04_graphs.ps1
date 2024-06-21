## Create a chart using Charts.js

<#
https://pshtml.readthedocs.io/en/latest/Charts/Charts/
https://www.chartjs.org/docs/latest/

In order to create a graph in pshtml, a few key things needs to be respected.

    - 1. a script tag with a reference to Chart.js library
    - 2. a canvas with a specific ID
    - 3. a dataset
    - 4. a chart which contains the dataset(s), and which is assigned the CanvasID.
    #>


$BarCanvasID = "barCanvas"
$htmlPage = html {
    head {
        title 'Bar Chart'

        # 1. a script tag with a reference to Chart.js library
        script -src "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.3/Chart.min.js" -type "text/javascript"
    }
    body {

        h1 "PSHTML Graph"

        div {

            p {
                "This is a bar graph"
            }
            # 2. a canvas with a specific ID
            canvas -Height 400px -Width 400px -Id $BarCanvasID {
            }

        }

        script -content {

            $barChartData = @(4,1,6,12,17,25,18,17,22,30,35,44)
            $barChartLabels = (New-Object System.Globalization.DateTimeFormatInfo).MonthNames

            $dsb1 = New-PSHTMLChartBarDataSet -Data $barChartData -label "Size (MB)" -backgroundColor 'blue' -hoverBackgroundColor 'red' -borderColor 'red' -hoverBorderColor 'red'
            New-PSHTMLChart -type bar -DataSet $dsb1 -title "Database Size in MB" -Labels $barChartLabels -CanvasID $BarCanvasID

        }

    }
}
$htmlPage | Out-File -FilePath ./web/graphs.html -Encoding utf8

<#
## Graph types

- Bar
- Doughnut
- Line
- Pie
- PolarArea
- Radar
#>
