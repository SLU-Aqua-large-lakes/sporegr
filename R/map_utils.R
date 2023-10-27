
#' sporeg_bbox
#'
#' Return bounding box for data frame. The data must contain two columns that
#' contains coordinates. Rows with NA in coordinates will be removed.
#'
#' @param x Data frame containing coordinates
#' @param lat character Column name or number containing latitude. Default "POSITIONN"
#' @param lon character Column name or number containing longitude. Default "POSITIONE"
#' @param buffer numeric the amount to buffer the map in all directions (default = .05)
#'
#' @return
#' Returns a bounding box as a vector of four named numbers. The numbers are named:
#' "left", "bottom", "right", and "top". This is the format used by ggmap::get_map()
#' @export
#'
sporeg_bbox <- function(x, lat = "POSITIONN", lon = "POSITIONE", buffer = .05) {
    coords <- x[ , c(lat, lon)]
    keep <-  !is.na(coords[, 1]) & !is.na(coords[, 2])
    coords <- coords[keep, ]
    res <- c(left = min(coords[, lon] - buffer),
             bottom = min(coords[, lat] - buffer),
             right = max(coords[, lon] + buffer),
             top = max(coords[, lat] + buffer))
    return(res)
}

#' sporeg_points
#'
#' Create an sf-multipoint from a data frame. The data must contain two columns that
#' contains coordinates. Rows with NA in coordinates will be dropped silently.
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
  coords <- x[ , c(lat, lon)]
  keep <-  !is.na(coords[, 1]) & !is.na(coords[, 2])
  resa <- resa[keep, ]
  res <- sf::st_as_sf(resa, coords = c(lon, lat), crs = 4326)
  return(res)
}
