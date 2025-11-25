# calc_date_breaks

Helper function to help calculate the number of breaks needed an a date
axis. The output is a string in the format "N days" suitable as value
for parameter date_breaks in scale_x_date() and friends.

## Usage

``` r
calc_date_breaks(first_date, last_date)
```

## Arguments

- first_date:

  a date or string that as.Date can convert to date

- last_date:

  a date or string that as.Date can convert to date

## Value

A character string

## Examples

``` r
calc_date_breaks("2022-06-01", "2022-06-18")
#> [1] "1 days"
```
