#### render.R ---------------
## render.R is part of library sporegr.
## render.R will render a PDF-report for all trips and all users found in the
## datafiles exported from the sporeg-datastore.
## To get a copy of this file use:
## copy.file(from = system.file("scripts", "render.R", package = "sporegr"),
##           to = "render.R")
##


library(dplyr)
library(sporegr)

## First get a copy of the RMD-template from package sporegr and save it as "yearly_template.Rmd"
## We will NOT overwrite the file so you must remove/rename any current file with this name
## if you want the latest version (for example When library(sporegr) is updated).

year_template <- "yearly_template.Rmd"
if (!file.exists(year_template)) {
  rmarkdown::draft(year_template,
                   template = "user-per-year",
                   package = "sporegr",
                   edit = FALSE)
}

## Files are read from a standard location by default.
## Uncomment and change the line below to change, see ?APEX_options for more info
## APEX_options(root_folder = ".")

resa_all <- read_resa_clean() %>%
  select(ANVID, Year) %>% distinct() %>%
  filter(Year != 2021) %>%
  filter(ANVID != "Peter") %>%
  arrange(ANVID, Year)

out_dir <- "Rapporter"
if (!dir.exists(out_dir)) {
  dir.create(out_dir)
}
for (i in 1:nrow(resa_all)) {
  User <- resa_all[i, ]$ANVID
  Year <- resa_all[i, ]$Year
  output_name <- paste0(User, Year, '.pdf')
  rmarkdown::render(year_template,
                    output_file = output_name,
                    output_dir = out_dir,
                    output_format="pdf_document",
                    envir = new.env(),
                    params = list(anvid = User,
                                  year_no = Year))
}

