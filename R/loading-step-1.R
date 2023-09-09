library(tidyverse)
library(jsonlite)

## last version enwiki-20230904-cirrussearch-content.json.gz

###### separate the wiki dump into chunked Rdata files

f = function(x, pos){
  filename = paste("chunks/chunk_", pos, ".RData", sep="")
  save(x, file = filename)
}

read_lines_chunked(file = 'input/enwiki-20230904-cirrussearch-content.json.gz', chunk_size = 100000, callback = SideEffectChunkCallback$new(f))

rm(f)
