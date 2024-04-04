require(sporegr)
require(dplyr)

anvid <- "gorsun"
year_no <- 2024


setwd("C:/R/sporegr/240402")
resa_name <- "Spöreg Resa.xlsx"
ovrighandelse_name <- "Spöreg Övrighändelse.xlsx"
fangst_name <- "Spöreg Fångst.xlsx"

# ... using functions included in library(sporeg)
resa <- read_resa_clean()  %>% filter(ANVID == anvid, Year == year_no)
resor_uuid <- resa %>% pull(UUID) %>% unique()
ovrighandelse <- read_ovrighandelse_clean() %>%
  filter(UUID %in% resor_uuid)
fangst <- read_fangst_clean() %>% filter(UUID %in% resor_uuid)
fangst <- fix_fangst_missing_fangstdattid(fangst, resa)
have_fangst <- nrow(fangst) > 0

## Create a table of trips with zero catch
zero_trips <- resa %>%
  select(UUID, FANGOMR, RESEDATUM, MALART, FISKEMINUTER, ANTALPERSONER) %>%
  left_join(fangst %>% group_by(UUID) %>% summarise(Antal = n())) %>%
  filter(is.na(Antal)) %>%
  mutate(Antal = 0, Effort = max(FISKEMINUTER)/60 * max(ANTALPERSONER), cpue = 0) %>%
  select(-UUID, -FISKEMINUTER, -ANTALPERSONER)

# put together trip and catch
fangst_resa <- resa %>%
  left_join(fangst, by = c("UUID" = "UUID"))

write.table(fangst_resa, "clipboard", quote=F, row.names=F, sep="\t")

## Andel återutsatt behöver beakta både "N" och "J" eftersom default är "NA".
# Skip for now. If used later, place below in its own chunk.
released_fangst <- fangst %>%
  filter(ATERUTSATT == "J") %>%
  summarise(released_fangst = n()) %>%
  pull(released_fangst)
