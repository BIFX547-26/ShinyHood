# ShinyHood


An example Shiny app illustrating various deployment methods. Ths Shiny
app displays information about the Hood College bioinformatics program
courses, which is neither complete nor up to date.

## Prerequisites

Install the required R packages before running the app:

``` r
install.packages(c("shiny", "bslib", "DT"))
```

## Running the App

### Clone the repository

``` bash
git clone https://github.com/BIFX547-26/ShinyHood
cd ShinyHood
```

Then launch from R:

``` r
shiny::runApp()
```

### Run directly from GitHub

``` r
shiny::runGitHub("BIFX547-26/ShinyHood")
```

### Run from a URL

``` r
shiny::runUrl("https://github.com/BIFX547-26/ShinyHood/raw/refs/heads/main/ShinyHood.zip")
```

### Run from a Gist

``` r
shiny::runGist("055fc0c7273b7ae8f932b1313b57cd2e")
```

## Deploying to connect.posit.cloud

<!-- add publisher icon support with 
quarto add mcanouil/quarto-iconify
Search icons at https://icon-sets.iconify.design/
-->

- Create a free account at [shinyapps.io](https://www.shinyapps.io) if
  you don’t have one.

- Follow the instructions above for running the app locally from the
  cloned repository, and verify that the app runs correctly.

- Open the Posit Publisher pane in
  [Positron](https://positron.posit.co/) by clicking on the icon on the
  left.

  - Click `+` under the `Credentials` drop down to add a new credential.
  - Select “Posit Connect Cloud” and follow the instructions for
    connecting Positron to the cloud.

- Open `app.R` and look for the Posit Publisher icon () near the top
  right of the file window.

  - Select a name for your app.
  - Select the Posit Connect Cloud account you would like to deploy to.
  - Update items in the Posit Publisher pane as needed.
  - Click “Deploy Your Project” to deploy.
  - If all goes well, a link to your app will appear in the Publisher
    window (next to the terminal window). You can also load the page by
    clicking on the “View Content” button in the Posit Publisher pane.
  - My deployment can be viewed
    [here](https://connect.posit.cloud/randyjohnson/content/019c967a-5c55-1508-bb00-ed842bdff629?utm_source=publisher-positron)
