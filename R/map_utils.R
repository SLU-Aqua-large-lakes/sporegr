
#' sporeg_bbox
#'
#' Return bounding box for data frame. The data must contain two columns that
#' contains coordinates
#'
#' @param x Data frame containing cordinates
#' @param lat character Column name or number containing latitude. Default "POSITIONN"
#' @param lon character Column name or number containing longitude. Default "POSITIONE"
#'
#' @return
#' Return a bounding box as a vector of four named numbers. The numbers are named:
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
