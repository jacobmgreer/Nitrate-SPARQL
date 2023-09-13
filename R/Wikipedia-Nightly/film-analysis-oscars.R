library(tidyverse)
library(jsonlite)
library(magrittr)
library(qdapRegex)

oscarfilms <-
  read_csv("~/Documents/Media-Consumption/datasets/Oscars/OscarsFilmSummary.csv") %>%
  left_join(.,
            find.imdblink %>%
              select(title, wikibase_item, FilmID, Studio, Distributor) %>%
              rename(wiki_title = title) %>%
              distinct(FilmID, .keep_all=TRUE),
            by="FilmID") %>%
  select(FilmID, FilmName, Year, Type, wiki_title, wikibase_item, Studio, Distributor) %T>%
  write.csv(., "output/oscarfilms-wiki-matches.csv", row.names = FALSE)
missing_wiki <- oscarfilms %>%
  filter(is.na(wikibase_item)) %T>%
  write.csv(., "output/oscarfilms-wiki-missing.csv", row.names = FALSE)

