## Using PSHTML to create a webapp in Azure

$reportCss = "
body {
    font-family: Arial, sans-serif;
}
.right {
    display: block;
    float: right;
    margin-left: auto;
    margin-right: 50;
}
ul {
    list-style-type: square;
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
            h1 {"Jess' PSConfEU 2024 Presentation - last updated on: {0}" -f (Get-Date -f 'yyyy-MM-dd')}
            img -src "https://i0.wp.com/psconf.eu/wp-content/uploads/2024/01/pomfret-shield24.png" -alt "Jess Pomfret" -style "width: 200px; height: 200px;" -class right align
        }
        p {
            # have copilot write a nice paragraph about the presentation
            "Welcome to my presentation on PSConfEU 2024. I'm Jess Pomfret and I'm excited to share with you all the things I've learnt about PSHTML and how you can use it to create webapps in Azure."
        }

        p {
            # also lets add an interesting fact about octopuses
            "Did you know that octopuses have three hearts and blue blood?"
        }

        h2 { "All the things we've learnt:"}

        ul {
            li {a "Demos are on GitHub" -href "https://github.com/jpomfret/pshtmlReports" }
            li {a "PSHTML on Github:" -href "https://github.com/Stephanevg/PSHTML" }
            li {a "PSHTML Docs:" -href "https://pshtml.readthedocs.io/" }
        }

        h2 { "All the pages we've built:"}

        ul {
            Get-ChildItem -Path .\web\* -File -Exclude index.html | Sort-Object Name | ForEach-Object {
                li {
                    a -href $_.Name -content $_.BaseName
                }
            }
        }
    }

}
# You can output it as a html file to review how it looks
$html > ./web/index.html
