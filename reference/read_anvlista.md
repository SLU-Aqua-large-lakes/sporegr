# Read a file with registered sporeg users

The location of the file read is predefined with but can be changed with
the function ?APEX_options(). The function uses file extension to select
how the file should be read. Known extensions are .csv and .xlsx. \#'

## Usage

``` r
read_anvlista()
```

## Value

Return a tibble

## Examples

``` r
if (FALSE) { # \dontrun{
  users <- read_anvlista()
} # }
```
