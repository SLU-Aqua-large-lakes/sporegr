# sporegApp

Start the sporeg shiny app.

## Usage

``` r
sporegApp()
```

## Details

Browse data from the Spöreg app in several different ways. Input data is
read from a predefined location (and filenames) that can be changed with
the
[`APEX_options`](https://kagervall.github.io/sporegr/reference/APEX_options.md)
function.

## Examples

``` r
if (FALSE) { # \dontrun{
library(sporeg)
# APEX_options(root_folder = "C:/your/folder") # if you have private copies
sporegApp()
} # }
```
