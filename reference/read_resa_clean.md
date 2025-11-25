# Read a file with APEX export of resor from Spöreg database and do some cleanup

The location of the file read is predefined with but can be changed with
the function
[`APEX_options()`](https://kagervall.github.io/sporegr/reference/APEX_options.md).
The function uses file extension to select how the file should be read.

## Usage

``` r
read_resa_clean()
```

## Value

Return a tibble

## Examples

``` r
if (FALSE) { # \dontrun{
  resor <- read_resa_clean()
} # }
```
