library(tidyverse)
library(tidytext)

setwd("~/Coursera/Scripts and Data/Capstone/Capstone")

data_dir <- file.path(getwd(), "datasets", "final", "en_US")
file_name <- "en_US.blogs.txt"

en_blogs <- read_lines(paste0(data_dir,"/", file_name),
                       n_max = 500,
                       skip_empty_rows = TRUE)

text_df <- tibble(line = 1:length(en_blogs), text = en_blogs)

# tokenization - separate into words 
text_df %>%
        unnest_tokens(word, text) %>%
        anti_join(stop_words) %>%
        count(word, sort = TRUE) %>%
        filter(n > 15) %>%
        mutate(word = reorder(word, n)) %>%
        ggplot(aes(n, word)) + geom_col() + labs(y = NULL)
