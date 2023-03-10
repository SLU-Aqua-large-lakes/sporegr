# Collection of functions that can be useful to make nicer Rmd documents.


# function for nicer plots
#' integer_breaks
#'
#' Put breaks only om integer values
#'
#' @param n Number of wanted breaks
#' @param ... passed to scales::pretty_breaks
#'
#' @return
#' a function
#' @export
#'
integer_breaks <- function(n = 5, ...) { # Helper function to get nicer scales
  breaker <- scales::breaks_extended(n, ...)
  function(x) {
    breaks <- breaker(x)
    breaks[breaks == floor(breaks)]
  }
}

#' calc_date_breaks
#'
#' Helper function to help calculate the number of breaks needed an a date axis.
#' The output is a string in the format "N days" suitable as value for parameter
#' date_breaks in scale_x_date() and friends.
#'
#' @param first_date a date or string that as.Date can convert to date
#' @param last_date a date or string that as.Date can convert to date
#'
#' @return
#' A character string
#' @export
#'
#' @examples
#' calc_date_breaks("2022-06-01", "2022-06-18")
calc_date_breaks <- function(first_date, last_date) {
  days_between <- floor(as.integer(
    diff(range(c(as.Date(first_date), as.Date(last_date))))) / 15
  )
  if (days_between < 1)
    days_between <- 1
  return(paste0(days_between, " days"))
}
