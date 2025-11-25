# sporeg_bbox

Return bounding box for data frame. The data must contain two columns
that contains coordinates. Rows with NA in coordinates will be removed.

## Usage

``` r
sporeg_bbox(x, lat = "POSITIONN", lon = "POSITIONE", buffer = 0.05)
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

- buffer:

  numeric the amount to buffer the map in all directions (default = .05)

## Value

Returns a bounding box as a vector of four named numbers. The numbers
are named: "left", "bottom", "right", and "top". This is the format used
by ggmap::get_map()
