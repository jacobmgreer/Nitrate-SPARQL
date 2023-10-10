library(tidyverse)
library(jsonlite)
library(magrittr)
library(qdapRegex)

AllMoviesDetailsCleaned <-
  AllMoviesDetailsCleaned %>%
  select(imdb_id, original_language, original_title, release_date, spoken_languages,
         title, production_companies, production_countries,
         spoken_languages_number, production_companies_number, production_countries_number) %T>%
  write.csv(., "output/moviesdb-films.csv", row.names = FALSE)

AllMovies.prod <-
  AllMoviesDetailsCleaned %>%
  select(production_companies, production_countries) %>%
  filter(production_companies != "none") %>%
  distinct() %T>%
  write.csv(., "output/moviesdb-prod.csv", row.names = FALSE)
