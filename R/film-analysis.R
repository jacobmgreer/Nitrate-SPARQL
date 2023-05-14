library(tidyverse)
library(jsonlite)
library(magrittr)
library(qdapRegex)

films <-
  list.files("output/wiki-exports", "*.csv") %>%
  map_df(~read_csv(paste0("output/wiki-exports/",.), show_col_types = FALSE)) %>%
  mutate(source_text = gsub("\\s+", " ", str_trim(source_text))) %>%
  arrange(desc(popularity_score))

find.imdblink <-
  films %>%
  filter(grepl("https://www.imdb.com/title/",external_link)) %>%
  mutate(FilmID = str_extract_all(external_link, "(?<=tt)\\d+")) %>%
  unnest(FilmID) %>%
  mutate(
    FilmID = paste0("tt", FilmID),
    Studio = str_extract(source_text, "studio = [^_ ]+(?:(?!distributor).)*"),
    Distributor = str_extract(source_text, "distributor = [^_ ]+(?:(?!released).)*")) %>%
  select(-c(source_text, external_link, weighted_tags)) %T>%
  write.csv(., "output/wiki-imdblinks.csv", row.names = FALSE)

test_imdblinks <- find.imdblink %>% count(FilmID)

find.infoboxfilm <- films %>%
  filter(grepl("Infobox film",source_text))

find.producer <- films%>%
  filter(grepl("Infobox film",source_text)) %>%
  filter(grepl("studio",source_text))
find.distributor <- films %>%
  filter(grepl("Infobox film",source_text)) %>%
  filter(grepl("distributor",source_text))

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
