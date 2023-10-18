required <- c("WikidataQueryServiceR", "tidyverse", "magrittr")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)

title_basics_tsv <-
  read_delim("~/Downloads/imdb/title.basics.tsv.gz",
             delim = "\t", escape_double = FALSE,
             trim_ws = TRUE) %>%
  filter(titleType == "movie")
title_crew <-
  read_delim("~/Downloads/imdb/title.crew.tsv",
             delim = "\t", escape_double = FALSE,
             trim_ws = TRUE) %>%
  select(tconst, directors) %>%
  separate_rows(directors)
name_basics_tsv <-
  read_delim("~/Downloads/imdb/name.basics.tsv.gz",
             delim = "\t", escape_double = FALSE,
             trim_ws = TRUE)

QID.IMDbCO <-
  read_csv("output/films/P345 - imdb.csv") %>%
  filter(grepl("^co", value)) %T>%
  write.csv(., file = "output/wikidata-imdb-companies.csv", row.names = FALSE)

QID.IMDbNM <-
  read_csv("output/films/P345 - imdb.csv") %>%
  filter(grepl("^nm", value)) %>%
  left_join(name_basics_tsv,
            by=c("value" = "nconst")) %T>%
  write.csv(., file = "output/wikidata-imdb-names.csv", row.names = FALSE)

QID.IMDbTT <-
  read_csv("output/films/P345 - imdb.csv") %>%
  filter(grepl("^tt", value)) %>%
  left_join(title_basics_tsv,
            by=c("value" = "tconst"))  %T>%
  write.csv(., file = "output/wikidata-imdb-films.csv", row.names = FALSE)

QID.IMDbDir <-
  read_csv("output/films/P345 - imdb.csv") %>%
  filter(grepl("^tt", value)) %>%
  left_join(title_crew %>%
            select(tconst, directors),
          by=c("value" = "tconst"),
          relationship = "many-to-many") %>%
  left_join(name_basics_tsv %>%
              select(nconst, primaryName),
            by=c("directors" = "nconst"),
            relationship = "many-to-many") %>%
  left_join(read_csv("output/films/P57 - director.csv"),
            by="QID",
            relationship = "many-to-many") %T>%
  write.csv(., file = "output/wikidata-imdb-directors.csv", row.names = FALSE)

rm(required, title_basics_tsv, name_basics_tsv, title_crew)
