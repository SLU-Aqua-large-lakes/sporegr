# Creating reports for the users of Spöreg

## Package `sporegr`

To install the package use:

``` r
remotes::install_github("kagervall/sporegr")
```

Then load the package:

``` r
library(sporegr)
```

Package `sporegr` contains

1.  Functions to read sporeg-data from a default file server or from
    local copies.

2.  Rmarkdown templates to create various reports from the data

3.  Functions used in the Rmd-templates to format the data nicely

4.  Script that automates the generation of reports

The data to analyse must first be downloaded from the central sporeg
database via the APEX interface
(<https://fd2.slu.se/ords/r/aqua/store100107/home>)

To use the script you need access to data files exported from the
central database or private copies of these files. By default `sporegr`
reads all data from: //storage-dh.slu.se/restricted\$/Stora
sjoarna/Projekt_uppdrag_aktiviteter/Fritidsfiske/Spöreg.

## Templates

This vignette describes the Rmarkdown templates available in package
sporegr. It also describes suggested workflows on howto create a
(possible) modified report for a single user or to generate reports for
all users in a single job. Templates fetched be used interactively or
from a script.

To fetch a template interactively in `Rstudio` go to `File` -\>
`New file` -\> `R Markdown`-\> `From Template` and choose one of the
`sporegr` templates.

To fetch a template from a script use:

``` r
 rmarkdown::draft(file = "my-repoert-template.Rmd",
                   template = "user-per-year",
                   package = "sporegr",
                   edit = FALSE)
```

### Available templates

After installation available templates can be listed:

``` r
rmarkdown::available_templates(package = "sporegr")
#> [1] "overview-total" "user-per-month" "user-per-year"
```

## Single user report. Interactive

To create a report for a single user for a specific month you create a
new .Rmd file by going to “File / New File / R Markdown…”, from the
popup that appear choose “From template” and then choose “Spöreg monthly
user report (sporegr)”.

Save this file in the directory where you want the report to be
generated. In the YAML-header of the Rmd file find the “params” block
and change “anvid”, “year_no” and “month_no” to the desired values.
Finally format your report by clicking “Knit”.

If needed you can modify the Rmd to customize the report for the user.

## All users yearly report

To create a yearly report for all users you can use the script
`render.R` includes in the package. To get a copy of the script run:

``` r
## Make a copy of the render.R script and save in in your current directory
file.copy(from = system.file("scripts", "render.R", package = "sporegr"),
          to = "render.R")
```

This script will make a yearly report for all users all years they have
fishing reported.
