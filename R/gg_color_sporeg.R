#' Create discrete scales for sporegr
#'
#' These functions set manual ggplot color scales conditional on names in Spöreg.
#'
#' Replaces the use of e.g. "scale_colour_manual()" and "scale_fill_manual().
#' pal <- c("#56B4E9", "#009E73", "#F0E442", "#0072B2", "#E69F00", "#D55E00")
#'
#' This ensures that each FANGOMR gets predesignated colors according to the standard in Fiskbarometern.
#' Could potentially also be used for ARTBEST/MALART
#'
#' @param ...
#'
#' @name sporegr_scales
#' @returns a ggplot2 color scale
#' @export
#'
scale_color_sporeg <- function(...){
  ggplot2:::manual_scale(
    "color",
    values = setNames(c("#009E73", "#56B4E9",  "#F0E442", "#0072B2", "#E69F00", "#D55E00", "#3B5323", "#4B0082"),
                      c("Mälaren", "Hjälmaren", "Vänern", "Vättern", "Storsjön", "Kust", "Övrigt vatten", "Nedre Dalälven"))
  )
}

#' @rdname sporegr_scales
#' @export
scale_fill_sporeg <- function(...){
  ggplot2:::manual_scale(
    "fill",
    values = setNames(c("#009E73", "#56B4E9",  "#F0E442", "#0072B2", "#E69F00", "#D55E00", "#3B5323", "#4B0082"),
                      c("Mälaren", "Hjälmaren", "Vänern", "Vättern", "Storsjön", "Kust", "Övrigt vatten", "Nedre Dalälven"))
  )
}

### Color by ARTBEST (or MALART)
# These could also be put within the scale_color_sporeg above, but for clarity I make a second function
# Needs to be updated as new species are included in the reported catch (this list per 2025 09 03)
# Colors are not from Fiskbarometern, but from SLU color palette (https://internt.slu.se/globalassets/mw/stod-serv/kommmarkn.for/kommunikator/img/farg_2019.pdf)
#' @rdname sporegr_scales
#' @export
scale_color_sporeg_art <- function(...){
  ggplot2:::manual_scale(
    "color",
    values = setNames(c("#154734", "#007681", "#fce300", "#509e2f", "#f6eb61", "#ff585d", "#ce0037", "#6ad1e3", "#d9d9d6", "#79863c",
                        "#d9d9d6", "#53565a", "#ffb81c", "#4b3d2a", "#c4d600", "#888b8d", "#d8ed96", "#fbd7c9",
                        "#672146", "#fbd7c9", "#996017", "#d8ed96", "#bbbcbc", "#000000"),
                      c("Gädda", "Öring", "Gös", "Abborre", "Id", "Harr", "Röding", "Lax",  "Björkna", "Asp",
                        "Storspigg", "Näbbgädda", "Makrill", "Pigghaj", "Torsk", "Gråsej", "Lyrtorsk", "Mört",
                        "Braxen", "Sarv", "Sandskädda", "Sutare", "Färna", "Ål"))
  )
}

#' @rdname sporegr_scales
#' @export
scale_fill_sporeg_art <- function(...){
  ggplot2:::manual_scale(
    "fill",
    values = setNames(c("#154734", "#007681", "#fce300", "#509e2f", "#f6eb61", "#ff585d", "#ce0037", "#6ad1e3", "#d9d9d6", "#79863c",
                        "#d9d9d6", "#53565a", "#ffb81c", "#4b3d2a", "#c4d600", "#888b8d", "#d8ed96", "#fbd7c9",
                        "#672146", "#fbd7c9", "#996017", "#d8ed96", "#bbbcbc", "#000000"),
                      c("Gädda", "Öring", "Gös", "Abborre", "Id", "Harr", "Röding", "Lax",  "Björkna", "Asp",
                        "Storspigg", "Näbbgädda", "Makrill", "Pigghaj", "Torsk", "Gråsej", "Lyrtorsk", "Mört",
                        "Braxen", "Sarv", "Sandskädda", "Sutare", "Färna", "Ål"))
  )
}
