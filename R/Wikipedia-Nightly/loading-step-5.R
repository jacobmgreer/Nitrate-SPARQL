library(tidyverse)
library(jsonlite)
library(magrittr)
library(qdapRegex)

find.imdblink <-
  films %>%
  #filter(grepl("https://www.imdb.com/title/",external_link)) %>%
  mutate(FilmID = str_extract_all(external_link, "(?<=tt)\\d+")) %>%
  unnest(FilmID) %>%
  mutate(
    FilmID = paste0("tt", FilmID),
    Studio = str_extract(source_text, "studio = [^_ ]+(?:(?!distributor).)*"),
    Distributor = str_extract(source_text, "distributor = [^_ ]+(?:(?!released).)*")) %>%
  select(-c(source_text, external_link, weighted_tags)) %T>%
  write.csv(., "output/wiki-imdblinks.csv", row.names = FALSE)

test_imdblinks <- find.imdblink %>% count(FilmID)

