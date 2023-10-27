
#' sporeg_bbox
#'
#' Return bounding box for data frame. The data must contain two columns that
#' contains coordinates
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
    x <- x %>%
      dplyr::filter(!is.na(!!as.symbol(lat))) %>%
      dplyr::filter(!is.na(!!as.symbol(lon)))
    res <- c(left = min(x[, lon] - buffer),
             bottom = min(x[, lat] - buffer),
             right = max(x[, lon] + buffer),
             top = max(x[, lat] + buffer))
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
