# Create discrete scales for sporegr

These functions set manual ggplot color scales conditional on names in
Spöreg.

## Usage

``` r
scale_color_sporeg(...)

scale_fill_sporeg(...)

scale_color_sporeg_art(...)

scale_fill_sporeg_art(...)
```

## Arguments

- ...:

## Value

a ggplot2 color scale

## Details

Replaces the use of e.g. "scale_colour_manual()" and
"scale_fill_manual(). pal \<- c("#56B4E9", "#009E73", "#F0E442",
"#0072B2", "#E69F00", "#D55E00")

This ensures that each FANGOMR gets predesignated colors according to
the standard in Fiskbarometern. Could potentially also be used for
ARTBEST/MALART
