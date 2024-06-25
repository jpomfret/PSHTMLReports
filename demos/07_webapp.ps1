## Using PSHTML to create a webapp in Azure

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
            h1 {"Jess' PSConfEU 2024 Presentation - last updated on: {0}" -f (Get-Date -f 'yyyy-MM-dd HH:mm:ss')}

            img -src "https://i0.wp.com/psconf.eu/wp-content/uploads/2024/01/pomfret-shield24.png" -alt "Jess Pomfret"  -Class float-end imgshadow -style "width: 200px; height: 200px;"
        }
        p {
            # have copilot write a nice paragraph about the presentation
            p {
                # have copilot write a nice paragraph about the presentation
                "This presentation is about using PSHTML to create a web app in Azure. It covers the basics of PSHTML, demonstrates how to use Bootstrap for styling, and provides useful links and resources for further learning."
            }
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
