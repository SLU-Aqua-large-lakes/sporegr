#require(stringr)
#require(lubridate)

#' Clean column names (internal)
#'
#' @param x
#'
#' @return character
#' @noRd
#'
.fix_names <- function(x) {
  x[x == "FANGOMR_NAMN"] <- "FANGOMR"
  x[x == "ARTBEST_NAMN"] <- "ARTBEST"
  x <-  stringr::str_split(x, pattern = '_', simplify = TRUE)
  x[ ,2] <- ifelse(x[ ,2] == "", x[ ,1], x[ ,2])
  return(x[ ,2])
}

#' Check if estimated or measured value (internal)
#'
#' @param MATT vector with measured values
#' @param EST  vector with estimated values
#'
#' @return boolean
#' @noRd
.is_estimated <- function(MATT, EST){
  res <- !is.na(EST)
  res[which(is.na(MATT) & is.na(EST))] <- NA # If both MATT and EST is NA result should also be NA
  return(res)
}

#' Choose between two values (internal)
#'
#' @param MATT  vector with measured values
#' @param EST vector with estimated values
#'
#' @return vector
#' @noRd
.choose_VALUE <- function(MATT, EST) {
  res <- ifelse(is.na(MATT), EST, MATT)
  return(res)
}

