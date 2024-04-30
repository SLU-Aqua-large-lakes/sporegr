##
## This file contains code needed to read and process Spöreg data exported
## from Oracle with the APEX interface.
##

## APEX options ##################################################################################
# Variable, global to package's namespace.
# This function is not exported to user space and does not need to be documented.
OPTIONS <- settings::options_manager(
  root_folder = "//storage-dh.slu.se/restricted$/Stora sjoarna/Projekt_uppdrag_aktiviteter/Fritidsfiske/Spöreg",
  resa = "Spöreg Resa.xlsx",
  fangst = "Spöreg Fångst.xlsx",
  ovrighandelse = "Spöreg Övrighändelse.xlsx",
  anvlista = "anvlista.xlsx")



# User function that gets exported:

#' Set or get options for reading APEX Spöreg data
#'
#' @param ... Option names to retrieve option values or \code{[key]=[value]} pairs to set options.
#'
#' @section Supported options:
#' Usually you only need to change \code{root_folder} but it is possible to also change file names
#' if needed. Supported keys:
#' \itemize{
#'  \item{\code{root_folder} Datafiles root (Default: //storage-dh.slu.se/restricted$/Stora sjoarna/Data/Fritidsfiskedata/Spöreg)}
#'  \item{\code{resa} File with trip occasions (Default: Spöreg Resa.xlsx)}
#'  \item{\code{fangst} File with catch/recatch data (Default: Spöreg Resa.xlsx)}
#'  \item{\code{ovrighandelse} File with misc events (Default: Spöreg Övrighändelse.xlsx)}
#'  \item{\code{anvlista} File with username, full name and organisation (Default: anvlista.xlsx)}
#' }
#'
#' @examples
#' # Show default
#' APEX_options()
#'
#' APEX_options(root_folder = "C:/myfolder") # Change folder where all files are located
#' APEX_options()$root_folder # Show the new value
#' settings::reset(APEX_options) # Reset to defaults
#'
#' @export
APEX_options <- function(...){
  # protect against the use of reserved words.
  settings::stop_if_reserved(...)
  OPTIONS(...)
}

## Data readers ##############################################################################################


#' Read a file with APEX export of resor from Spöreg database and do some cleanup
#'
#' The location of the file read is predefined with but can be changed with
#' the function [APEX_options()].
#' The function uses file extension to select how the file should be read.
#' Known extensions are .csv and .xlsx.
#'
#' @return
#' Return a tibble
#' @export
#'
#' @examples
#' \dontrun{
#'   resor <- read_resa_clean()
#' }
read_resa_clean <- function() {
  file_name <- file.path(APEX_options()$root_folder, APEX_options()$resa)
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
    dplyr::mutate(Year = lubridate::year(RESEDATUM),
                  Month = lubridate::month(RESEDATUM),
                  Day = lubridate::day(RESEDATUM),
                  Quarter = lubridate::quarter(RESEDATUM))
  return(res)
}

#' Read a file with APEX export of Övrighändelse from Spöreg database and do some cleanup
#'
#' The function uses file extension to select how the file should be read.
#' Known extensions are .csv and .xlsx.
#'
#' @return
#' Return a tibble
#' @export
#'
#' @examples
#' \dontrun{
#' ovr <- read_ovrighandelse_clean()
#' }
read_ovrighandelse_clean <- function() {
  file_name <- file.path(APEX_options()$root_folder, APEX_options()$ovrighandelse)
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
#'
#' @return
#' Return a tibble
#' @export
#'
#' @examples
#' \dontrun{
#' fangst <- read_fangst_clean()
#' }
read_fangst_clean <- function() {
  file_name <- file.path(APEX_options()$root_folder, APEX_options()$fangst)
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
    dplyr::select(UUID, ARTBEST, FANGSTDATTID, LANGD, is_est_LANGD,
                  VIKT, is_est_VIKT, ATERUTSATT, ODLAD, MARKNING, KLIPPTFENAHOGER,
                  KLIPPTFENAVANSTER, AVVIKELSE, POSITIONN, POSITIONE) %>%
    dplyr::mutate(Hour = lubridate::hour(as.POSIXlt(FANGSTDATTID,  format = "%Y-%m-%d %H:%M")),
                  Minute = lubridate::minute(as.POSIXlt(FANGSTDATTID,  format = "%Y-%m-%d %H:%M")))
  return(res)
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


#' Read a file with registered sporeg users
#'
#' The location of the file read is predefined with but can be changed with
#' the function ?APEX_options().
#' The function uses file extension to select how the file should be read.
#' Known extensions are .csv and .xlsx.
#'#'
#' @return
#' Return a tibble
#' @export
#'
#' @examples
#' \dontrun{
#'   users <- read_anvlista()
#' }
read_anvlista <- function() {
  file_name <- file.path(APEX_options()$root_folder, APEX_options()$anvlista)
  fext <- tools::file_ext(file_name)
  if (!(fext %in% c("csv", "xlsx")))  stop("unknown file type")
  if (fext == "csv") {
    rawdata <- utils::read.csv(file_name, fileEncoding = "latin1")
  } else if (fext == "xlsx"){
    rawdata <- readxl::read_excel(file_name)
  }
  res <- rawdata
  return(res)
}
