## Using PSHTML to create a webapp in Azure

if ($results) {

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
                img -src "img/pomfret.png" -alt "Jess Pomfret" -style "width: 200px; height: 200px;" -class right align
            }
            p {
                # have copilot write a nice paragraph about the presentation
                "This is a presentation about how to use PSHTML to create a webapp in Azure. It will cover how to create a webapp, how to deploy it to Azure, and how to use it to display information."
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
                Get-ChildItem -Path .\web -Recurse -Exclude index.html | Sort-Object Name | ForEach-Object {
                    li {
                        a -href $_.Name -content $_.BaseName
                    }
                }
            }
        }

    }
    # You can output it as a html file to review how it looks
    $html > ./web/index.html
}