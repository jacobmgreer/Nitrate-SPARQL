library(WikidataQueryServiceR)
library(tidyverse)
library(jsonlite)
library(magrittr)
library(glue)

options(readr.show_col_types = FALSE)
options(dplyr.summarise.inform = FALSE)

formatted <-
  read_csv("~/Github/Media-Consumption/ratings/formatted.csv") %>%
  select(-c(Your.Rating, Date.Rated, IMDb.Rating, Num.Votes, AFI, Theater, Service))

Films.Basic <- read_csv("input/WQS-exports/formatted-basic.csv") %>% distinct(imdb, .keep_all=TRUE)

Films.Distributor <-
  read_csv("input/WQS-exports/formatted-distributor.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    distIDs = str_c(basename(distid), collapse = ","),
    distributors = str_c(str_c('"', distributor, '"'), collapse = ","))

Films.Genres <-
  read_csv("input/WQS-exports/formatted-genres.csv") %>%
  filter(!is.na(genre_id)) %>%
  group_by(item, imdb) %>%
  summarize(
    genreIDs = str_c(basename(genre_id), collapse = ","),
    genres = str_c(str_c('"', genre, '"'), collapse = ","))

Films.IA <-
  read_csv("input/WQS-exports/formatted-ia.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    ia = str_c(str_c('"', ia, '"'), collapse = ","))

Films.Language <-
  read_csv("input/WQS-exports/formatted-language.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    langIDs = str_c(basename(langid), collapse = ","),
    languages = str_c(str_c('"', language, '"'), collapse = ","))

Films.MediaType <-
  read_csv("input/WQS-exports/formatted-mediatype.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    mediaIDs = str_c(basename(mediaid), collapse = ","),
    mediatypes = str_c(str_c('"', mediatype, '"'), collapse = ","))

Films.Origin <- read_csv("input/WQS-exports/formatted-origin.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    originIDs = str_c(basename(originid), collapse = ","),
    origins = str_c(str_c('"', origin, '"'), collapse = ","))

Films.Production <- read_csv("input/WQS-exports/formatted-production.csv") %>%
  group_by(item, imdb) %>%
  summarize(
    prodIDs = str_c(basename(prodid), collapse = ","),
    production = str_c(str_c('"', production, '"'), collapse = ","))

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
  select(QID, everything()) %T>%
  write.csv(., file = "output/watchlist-with-wikidata.csv")

rm(list=ls(pattern="^Films."))
rm(formatted)
