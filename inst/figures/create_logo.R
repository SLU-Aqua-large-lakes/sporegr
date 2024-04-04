
library(hexSticker)

imgurl <- "inst/figures/Appikon_1024x1024.png"
s <- sticker(imgurl, s_x = 1.03, s_y = .9, s_width = .5,
             package="sporegr", p_size = 20, p_y = 1.6,
             h_fill =  "#267a82", h_color = "#6ad1e3",
             filename="inst/figures/hexsticker.png")


usethis::use_logo("inst/figures/hexsticker.png")
