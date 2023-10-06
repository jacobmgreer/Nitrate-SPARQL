library(tidyverse)
library(jsonlite)
library(magrittr)
library(qdapRegex)

WikiData.film <-
  WikiData.Films %>%
  filter(grepl("^tt",imdb))
