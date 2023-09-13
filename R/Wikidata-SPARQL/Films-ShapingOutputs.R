library(WikidataQueryServiceR)
library(tidyverse)
library(jsonlite)
library(magrittr)
library(glue)

options(readr.show_col_types = FALSE)
options(dplyr.summarise.inform = FALSE)

formatted <- read_csv("~/Github/Media-Consumption/ratings/formatted.csv")

Films.Basic <- read_csv("input/WQS-exports/formatted-basic.csv") %>% distinct(imdb, .keep_all=TRUE)

Films.Distributor <-
  read_csv("input/WQS-exports/formatted-distributor.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    distIDs = list(distid),
    distributors = list(distributor))

Films.Genres <-
  read_csv("input/WQS-exports/formatted-genres.csv") %>%
  filter(!is.na(genre_id)) %>%
  group_by(item, imdb) %>%
  summarize(
    genreIDs = list(genre_id),
    genres = list(genre))

Films.IA <-
  read_csv("input/WQS-exports/formatted-ia.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    ia = list(ia))

Films.Language <-
  read_csv("input/WQS-exports/formatted-language.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    langIDs = list(langid),
    langunages = list(language))

Films.MediaType <-
  read_csv("input/WQS-exports/formatted-mediatype.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    mediaIDs = list(mediaid),
    mediatypes = list(mediatype))

Films.Origin <- read_csv("input/WQS-exports/formatted-origin.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    originIDs = list(originid),
    origins = list(origin))

Films.Production <- read_csv("input/WQS-exports/formatted-production.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    prodIDs = list(prodid),
    production = list(production))

Watchlist.Wikidata <-
  left_join(formatted %>% rename(imdb=Const), Films.Basic, by="imdb") %>%
  left_join(., Films.Distributor, by=c("item","imdb")) %>%
  left_join(., Films.Genres, by=c("item","imdb")) %>%
  left_join(., Films.IA, by=c("item","imdb")) %>%
  left_join(., Films.Language, by=c("item","imdb")) %>%
  left_join(., Films.MediaType, by=c("item","imdb")) %>%
  left_join(., Films.Origin, by=c("item","imdb")) %>%
  left_join(., Films.Production, by=c("item","imdb")) %>%
  mutate(QID = basename(item)) %>%
  select(QID, everything())

Watchlist.Wikidata %>%
  as_tibble() %>%
  mutate_all(~ as.character(.)) %>%
  write.csv(., file = "output/watchlist-with-wikidata.csv")

save(Watchlist.Wikidata, file = "output/watchlist-with-wikidata.RData")

rm(list=ls(pattern="^Films."))
rm(formatted)
