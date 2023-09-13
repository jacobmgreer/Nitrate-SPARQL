library(tidyverse)
library(jsonlite)

## last version enwiki-20230904-cirrussearch-content.json.gz

###### separate the wiki dump into chunked Rdata files

f = function(x, pos){
  filename = paste("output/chunks/chunk_", pos, ".RData", sep="")
  save(x, file = filename)
}

read_lines_chunked(file = 'input/imdbdump.gz', chunk_size = 100000, callback = SideEffectChunkCallback$new(f))

rm(f)
