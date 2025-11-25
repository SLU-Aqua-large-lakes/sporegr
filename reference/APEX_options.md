# Set or get options for reading APEX Spöreg data

Set or get options for reading APEX Spöreg data

## Usage

``` r
APEX_options(...)
```

## Arguments

- ...:

  Option names to retrieve option values or `[key]=[value]` pairs to set
  options.

## Supported options

Usually you only need to change `root_folder` but it is possible to also
change file names if needed. Supported keys:

- `root_folder` Datafiles root (Default:
  //storage-dh.slu.se/restricted\$/Stora
  sjoarna/Data/Fritidsfiskedata/Spöreg)

- `resa` File with trip occasions (Default: Spöreg Resa.xlsx)

- `fangst` File with catch/recatch data (Default: Spöreg Resa.xlsx)

- `ovrighandelse` File with misc events (Default: Spöreg
  Övrighändelse.xlsx)

- `anvlista` File with username, full name and organisation (Default:
  anvlista.xlsx)

## Examples

``` r
# Show default
APEX_options()
#> $root_folder
#> [1] "//storage-dh.slu.se/restricted$/Stora sjoarna/Projekt_uppdrag_aktiviteter/Fritidsfiske/Spöreg"
#> 
#> $resa
#> [1] "Spöreg Resa.xlsx"
#> 
#> $fangst
#> [1] "Spöreg Fångst.xlsx"
#> 
#> $ovrighandelse
#> [1] "Spöreg Övrighändelse.xlsx"
#> 
#> $anvlista
#> [1] "anvlista.xlsx"
#> 

APEX_options(root_folder = "C:/myfolder") # Change folder where all files are located
APEX_options()$root_folder # Show the new value
#> [1] "C:/myfolder"
settings::reset(APEX_options) # Reset to defaults
```
