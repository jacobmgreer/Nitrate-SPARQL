library(tidyverse)
library(jsonlite)

## separate the wiki dump into chunked Rdata files

f = function(x, pos){
  filename = paste("chunks/chunk_", pos, ".RData", sep="")
  save(x, file = filename)
}

read_lines_chunked(file = 'enwiki-20230501-cirrussearch-content.json', chunk_size = 100000, callback = SideEffectChunkCallback$new(f))
