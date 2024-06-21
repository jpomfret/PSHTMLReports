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

            $Data3 = @(4,1,6,12,17,25,18,17,22,30,35,44)
            $Labels = @("January","February","Mars","April","Mai","June","July","August","September","October","November","december")

            # 3. a dataset
            $dsb3 = New-PSHTMLChartBarDataSet -Data $data3 -label "2018" -BackgroundColor ('blue')

            # 4. a chart which contains the dataset(s), and which is assigned the CanvasID.
            New-PSHTMLChart -type bar -DataSet $dsb3 -title "Bar Chart Example" -Labels $Labels -CanvasID $BarCanvasID

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