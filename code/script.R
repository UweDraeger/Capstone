library(tidyverse)
library(tidytext)

setwd("~/Coursera/Scripts and Data/Capstone")

data_dir <- file.path(getwd(), "datasets", "final", "en_US")

tw_file_name <- "en_US.twitter.txt"
bl_file_name <- "en_US.blogs.txt"
nw_file_name <- "en_US.news.txt"

twitter_data <- read_lines(paste0(data_dir,"/", tw_file_name),
                           n_max = 5000,
                           skip_empty_rows = TRUE)
blogs_data <- read_lines(paste0(data_dir,"/", bl_file_name),
                       skip_empty_rows = TRUE)
news_data <- read_lines(paste0(data_dir,"/", nw_file_name),
                       skip_empty_rows = TRUE)

tw_text <- tibble(line = 1:length(twitter_data), text = twitter_data)
bl_text <- tibble(line = 1:length(blogs_data), text = blogs_data)
nw_text <- tibble(line = 1:length(news_data), text = news_data)

# tokenization - separate into words 
tw_words <- tw_text %>%
        unnest_tokens(word, text) %>%
        count(word, sort = TRUE)

bl_words <- bl_text %>%
        unnest_tokens(word, text) 
        anti_join(stop_words)

nw_words <- nw_text %>%
        unnest_tokens(word, text) 
        anti_join(stop_words)
        
# tokenization - separate into ngrams
tw_2grams <- tw_text %>%
        unnest_tokens(ngram, text, token = "ngrams", n = 2)  %>%
        count(ngram, sort = TRUE)

tw_3grams <- tw_text %>%
        unnest_tokens(ngram, text, token = "ngrams", n = 3)  %>%
        count(ngram, sort = TRUE)
