
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

#' Read a file with APEX export of resor from Spöreg database and do some cleanup
#'
#' The function uses file extension to select how the file should be read.
#' Known extensions are .csv and .xlsx.
#'
#' @param file_name character Default "Spöreg Resa.csv"
#'
#' @return
#' Return a tibble
#' @export
#'
#' @examples
#' \dontrun{
#'   resor <- read_resa_clean()
#' }
read_resa_clean <- function(file_name = "Sp\u00f6reg Resa.csv") {
  fext <- tools::file_ext(file_name)
  if (!(fext %in% c("csv", "xlsx")))  stop("unknown file type")
  if (fext == "csv") {
    rawdata <- utils::read.csv(file_name, fileEncoding = "latin1")
  } else if (fext == "xlsx"){
    rawdata <- readxl::read_excel(file_name)
  }
  res <- rawdata %>%
    dplyr::select(-ANV_ID, -SPOREGRESA_APPVERSION, -SPOREGSTOPP_STARTDATTID, - SPOREGSTOPP_STOPDATTID) %>%
    dplyr::rename_with(.fn = .fix_names) %>%
    dplyr::mutate(RESEDATUM = as.Date(RESEDATUM)) %>%
    dplyr::mutate(Year = lubridate::year(RESEDATUM), Month = lubridate::month(RESEDATUM))
  return(res)
}

#' Read a file with APEX export of Övrighändelse from Spöreg database and do some cleanup
#'
#' The function uses file extension to select how the file should be read.
#' Known extensions are .csv and .xlsx.
#
#' @param file_name character Default "Spöreg Övrighändelse.csv"
#'
#' @return
#' Return a tibble
#' @export
#'
#' @examples
#' \dontrun{
#' ovr <- read_ovrighandelse_clean()
#' }
read_ovrighandelse_clean <- function(file_name = "Sp\u00f6reg \u00c5vrigh\u00e4ndelse.csv") {
  fext <- tools::file_ext(file_name)
  if (fext == "csv") {
    rawdata <- utils::read.csv(file_name, fileEncoding = "latin1")
  } else if (fext == "xlsx"){
    rawdata <- readxl::read_excel(file_name) %>%
      dplyr::mutate(SPOREGOVHAND_STARTDATTID =
                      base::format(SPOREGOVHAND_STARTDATTID,
                                   format = "%Y-%m-%d %H:%M")) %>%
      dplyr::mutate(SPOREGOVHAND_STARTDATTID =
                      dplyr::if_else(is.na(SPOREGOVHAND_STARTDATTID),
                                     "",
                                     SPOREGOVHAND_STARTDATTID))
  }
  res <- rawdata %>%
    dplyr::rename_with(.fn = .fix_names) %>%
    dplyr::select(UUID, STARTDATTID, ANTAL, POSITIONN, POSITIONE, HANDELSE)
}

#' Read a file with APEX export of fångster from Spöreg database and do some cleanup
#'
#' The function uses file extension to select how the file should be read.
#' Known extensions are .csv and .xlsx.
#
#' @param file_name character Default "Spöreg Fångst.csv"
#'
#' @return
#' Return a tibble
#' @export
#'
#' @examples
#' \dontrun{
#' fangst <- read_fangst_clean()
#' }
read_fangst_clean <- function(file_name = "Sp\u00f6reg F\u00e5ngst.csv") {
  fext <- tools::file_ext(file_name)
  if (fext == "csv") {
    rawdata <- utils::read.csv(file_name, fileEncoding = "latin1")
  } else if (fext == "xlsx"){
    rawdata <- readxl::read_excel(file_name) %>%
      dplyr::mutate(SPOREGIND_FANGSTDATTID =
                      base::format(SPOREGIND_FANGSTDATTID,
                                   format = "%Y-%m-%d %H:%M")) %>%
      dplyr::mutate(SPOREGIND_FANGSTDATTID =
                      dplyr::if_else(is.na(SPOREGIND_FANGSTDATTID),
                                           "",
                                           SPOREGIND_FANGSTDATTID))
  }
  res <- rawdata %>%
    dplyr::rename_with(.fn = .fix_names) %>%
    dplyr::mutate(LANGD = .choose_VALUE(MATTLANGD, ESTLANGD),
           is_est_LANGD = .is_estimated(MATTLANGD, ESTLANGD)) %>%
   dplyr::mutate(VIKT = .choose_VALUE(MATTVIKT, ESTVIKT),
           is_est_VIKT = .is_estimated(MATTVIKT, ESTVIKT)) %>%
    dplyr::select(UUID, ARTBEST, FANGSTDATTID, LANGD, is_est_LANGD, ESTVIKT,
                  VIKT, is_est_VIKT, ATERUTSATT, ODLAD, MARKNING, KLIPPTFENAHOGER,
                  KLIPPTFENAVANSTER, AVVIKELSE, POSITIONN, POSITIONE)
}

#' Fix missing datetime on fangster
#'
#' @param f data.frame with fangster as returned by read_fangst_clean()
#' @param r data.frame with resor as returned by read_resa_clean()
#'
#' @return
#' a data.frame where catches with missing FANGSTDATTID have their FANGSTDATTID set
#' to RESEDATUM "12:00:00"
#' @export
#'
#' @examples
#' \dontrun{
#' fangst <- fix_fangst_missing_fangstdattid(fangst, resa)
#' }
fix_fangst_missing_fangstdattid <- function(f, r){
  r <- r %>%
    dplyr::mutate(rdate = paste0(RESEDATUM, " 12:00:00")) %>%
    dplyr::select(UUID, rdate)
  fixed_fangst <- f %>%
    dplyr::left_join(r, by = "UUID") %>%
    dplyr::mutate(FANGSTDATTID = dplyr::if_else(FANGSTDATTID == "", rdate, FANGSTDATTID)) %>%
    dplyr::select(-rdate)
  return(fixed_fangst)
}
