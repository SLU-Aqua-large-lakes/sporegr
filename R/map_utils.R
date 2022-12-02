
#' sporeg_bbox
#'
#' Return bounding box for data frame. The data must contain two columns that
#' contains coordinates
#'
#' @param x Data frame containing coordinates
#' @param lat character Column name or number containing latitude. Default "POSITIONN"
#' @param lon character Column name or number containing longitude. Default "POSITIONE"
#'
#' @return
#' Returns a bounding box as a vector of four named numbers. The numbers are named:
#' "left", "bottom", "right", and "top". This is the format used by ggmap::get_map()
#' @export
#'
sporeg_bbox <- function(x, lat = "POSITIONN", lon = "POSITIONE") {
    res <- c(left = min(x[, lon]),
             bottom = min(x[, lat]),
             right = max(x[, lon]),
             top = max(x[, lat]))
    return(res)
}

#' sporeg_points
#'
#' Create an sf-multipoint from a data frame. The data must contain two columns that
#' contains coordinates
#'
#' @param x Data frame containing coordinates
#' @param lat character Column name or number containing latitude. Default "POSITIONN"
#' @param lon character Column name or number containing longitude. Default "POSITIONE"
#'
#' @return
#' Returns a sf multipoint object.
#' @export
#'
sporeg_points <- function(x, lat = "POSITIONN", lon = "POSITIONE") {
  res <- sf::st_as_sf(resa, coords = c("POSITIONE", "POSITIONN"), crs = 4326)
  return(res)
}
