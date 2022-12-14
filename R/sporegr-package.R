#' sporegr: tools and templates to work with and create reports from Spöreg data
#'
#' This package will help you Work with data from the Spöreg mobile app. The package contains
#' functions to read (and do some cleanup) of data files exported from predefined queries in APEX.
#'
#' @section Data Import and Export:
#'
#' Functions to import data from csv or xlsx files exported from the APEX
#' service (\url{https://fd2.slu.se/ords/r/aqua/store100107/home}). Some cleanup
#' and renaming is done to make the dataset more R friendly.
#'
#' \itemize{
#'  \item \code{\link{read_resa_clean}}:  import data from with trip info (_resor_)
#'  \item \code{\link{read_fangst_clean}}:  import data from with catches (_fångst_)
#'  \item \code{\link{read_fangst_ovrighandelse}}:  import data from with misc data
#' }
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
## usethis namespace: end
NULL
