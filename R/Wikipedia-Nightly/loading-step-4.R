library(tidyverse)
library(jsonlite)
library(magrittr)
library(qdapRegex)

find.imdb.tt <-
  films %>%
  filter(grepl("imdb.com/title",external_link)) %>%
  mutate(
    FilmID = str_extract_all(external_link, "(?<=title/tt)\\d+")) %>%
  unnest(FilmID) %>%
  mutate(
    FilmID = paste0("tt", FilmID)) %>%
  select(-c(name, weighted_tags, source_text, text, opening_text, external_link, text_bytes, popularity_score)) %T>%
  write.csv(., "output/wiki-imdb-films.csv", row.names = FALSE)

find.imdb.co <-
  films %>%
  filter(grepl("imdb.com/company",external_link)) %>%
  mutate(
    CompanyID = str_extract_all(external_link, "(?<=company/co)\\d+")) %>%
  unnest(CompanyID) %>%
  mutate(
    CompanyID = paste0("co", CompanyID)) %>%
  select(-c(name, weighted_tags, source_text, text, opening_text, external_link, text_bytes, popularity_score)) %T>%
  write.csv(., "output/wiki-imdb-companies.csv", row.names = FALSE)

find.imdb.nm <-
  films %>%
  filter(grepl("imdb.com/name",external_link)) %>%
  mutate(
    PersonID = str_extract_all(external_link, "(?<=name/nm)\\d+")) %>%
  unnest(PersonID) %>%
  mutate(
    PersonID = paste0("nm", PersonID)) %>%
  select(-c(name, weighted_tags, source_text, text, opening_text, external_link, text_bytes, popularity_score)) %T>%
  write.csv(., "output/wiki-imdb-people.csv", row.names = FALSE)

find.wiki.prod <-
  films %>%
  mutate(
    Studio = str_extract(source_text, "studio = [^_]+?(?=\\|)")
  ) %>%
  filter(!is.na(Studio)) %>%
  select(-c(name, weighted_tags, source_text, text, opening_text, external_link, text_bytes, popularity_score)) %T>%
  write.csv(., "output/wiki-prod.csv", row.names = FALSE)

find.wiki.dist <-
  films %>%
  mutate(
    Distributor = str_extract(source_text, "distributor = [^_]+?(?=\\|)")
  ) %>%
  filter(!is.na(Distributor)) %>%
  select(-c(name, weighted_tags, source_text, text, opening_text, external_link, text_bytes, popularity_score)) %T>%
  write.csv(., "output/wiki-dist.csv", row.names = FALSE)

