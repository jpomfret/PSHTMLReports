# let's create a form with some javascript (written by CoPilot)

$jsScript = @'
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('#myForm');
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            const limit = document.querySelector('input[name="fact"]').value;
            const url = limit ? `https://catfact.ninja/facts?limit=${limit}` : 'https://catfact.ninja/facts/';
            fetch(url)
                .then(response => response.json())
                .then(facts => showFacts(facts.data));
        });

        showFacts = facts => {
            const factsDiv = document.querySelector('#catFact');
            factsDiv.innerHTML = ''; // Clear the div
            facts.forEach(fact => {
                const factElement = document.createElement('p');
                factElement.innerText = `Fact: ${fact.fact}`;
                factsDiv.append(factElement);
            });
        }
    });
'@

$htmlForm = html {
    head {
        title 'Cat Fact Form'
        script -type text/javascript -content $jsScript
    }
    body {

        h1 "Let's get a cat fact"

        form -Id 'myForm' -method post -enctype text/plain -action self -Content {
            input -id fact fact -type text
            input -name "Get Cat Fact" -type submit
        }

        div -Id 'catFact' {
        }

    }
}
$htmlForm | Out-File -FilePath ./web/forms.html -Encoding utf8
