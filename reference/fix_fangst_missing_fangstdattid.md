# Fix missing datetime on fangster

Fix missing datetime on fangster

## Usage

``` r
fix_fangst_missing_fangstdattid(f, r)
```

## Arguments

- f:

  data.frame with fangster as returned by read_fangst_clean()

- r:

  data.frame with resor as returned by read_resa_clean()

## Value

a data.frame where catches with missing FANGSTDATTID have their
FANGSTDATTID set to RESEDATUM "12:00:00"

## Examples

``` r
if (FALSE) { # \dontrun{
fangst <- fix_fangst_missing_fangstdattid(fangst, resa)
} # }
```
