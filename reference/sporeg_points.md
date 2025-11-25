# sporeg_points

Create an sf-multipoint from a data frame. The data must contain two
columns that contains coordinates. Rows with NA in coordinates will be
dropped silently.

## Usage

``` r
sporeg_points(x, lat = "POSITIONN", lon = "POSITIONE")
```

## Arguments

- x:

  Data frame containing coordinates

- lat:

  character Column name or number containing latitude. Default
  "POSITIONN"

- lon:

  character Column name or number containing longitude. Default
  "POSITIONE"

## Value

Returns a sf multipoint object.
