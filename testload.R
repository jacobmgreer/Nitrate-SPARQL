library(tidyverse)
library(jsonlite)
library(magrittr)

##### Unpacking the RData json data

for (dir in 1:2) {
  WikiJson <- NULL

  for (i in list.files(paste0("chunks/", dir), "*.RData")) {
    WikiJson[[i]] <- get(load(paste0("chunks/", dir, "/", i)))
  }

  WikiJson %>%
    enframe %>%
    unnest(cols = c(value)) %>%
    filter(!grepl('^\\{\"index\"', value)) %>%
    rowwise() %>%
    mutate(data = list(fromJSON(value))) %>%
    unnest_wider(data) %>%
    select(-value) %>%
    write.csv(., paste0("output/wiki-exports/reformatted-wiki-", dir, ".csv"), row.names = FALSE)

  rm(i, x, dir, WikiJson)
}

##### turn into WikiJson into dataframe

WikiJson2 <-
  WikiJson %>%
  enframe %>%
  unnest(cols = c(value)) %>%
  filter(!grepl('^\\{\"index\"', value)) %>%
  rowwise() %>%
  mutate(data = list(fromJSON(value))) %>%
  unnest_wider(data) %>%
  select(-value)

## find film related content

test_find <- WikiJson2 %>% filter(grepl("film)",title))

imdb_find <- WikiJson2 %>% filter(grepl("imdb",external_link))

r_find <- WikiJson2 %>% filter(grepl("Repulsion",title))
