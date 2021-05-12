library(tidyverse)
library(tidytext)

setwd("~/Coursera/Scripts and Data/Capstone")

data_dir <- file.path(getwd(), "datasets", "final", "en_US")

tw_file_name <- "en_US.twitter.txt"
bl_file_name <- "en_US.blogs.txt"
nw_file_name <- "en_US.news.txt"

twitter_data <- read_lines(paste0(data_dir,"/", tw_file_name),
                           skip_empty_rows = TRUE)

blogs_data <- 
        read_lines(paste0(data_dir,"/", bl_file_name), 
                   skip_empty_rows = TRUE)
news_data <- read_lines(paste0(data_dir,"/", nw_file_name), skip_empty_rows = TRUE)

tw_text <- tibble(line = 1:length(twitter_data), text = twitter_data)
bl_text <- tibble(line = 1:length(blogs_data), text = blogs_data)
nw_text <- tibble(line = 1:length(news_data), text = news_data)

# tokenization - separate into words 
tw_words <- tw_text %>%
        unnest_tokens(word, text) %>%
        count(word, sort = TRUE)
bl_words <- bl_text %>% unnest_tokens(word, text) %>% count(word, sort = TRUE)
nw_words <- nw_text %>% unnest_tokens(word, text) %>% count(word, sort = TRUE)
        
# tokenization - separate into ngrams

tw_2grams <- tw_text %>%
        unnest_tokens(bigram, text, token = "ngrams", n = 2)  %>%
        count(bigram, sort = TRUE)
tw_3grams <- tw_text %>%
        unnest_tokens(trigram, text, token = "ngrams", n = 3)  %>%
        count(trigram, sort = TRUE)
# bl_2grams <- bl_text %>% unnest_tokens(bigram, text, token = "ngrams", n = 2)  %>% count(bigram, sort = TRUE)
# bl_3grams <- bl_text %>% unnest_tokens(trigram, text, token = "ngrams", n = 3)  %>% count(trigram, sort = TRUE)

# nw_2grams <- nw_text %>% unnest_tokens(bigram, text, token = "ngrams", n = 2)  %>% count(bigram, sort = TRUE)
# nw_3grams <- nw_text %>% unnest_tokens(trigram, text, token = "ngrams", n = 3)  %>% count(trigram, sort = TRUE)


total_tw_words <- sum(tw_words$n)
# total_bl_words <- sum(bl_words$n)
# total_nw_words <- sum(nw_words$n)

tw_words <- tw_words %>%
        mutate(freq = n / total_tw_words) %>%
        mutate(cumfreq = cumsum(freq))
# bl_words <- bl_words %>% mutate(freq = n / total_bl_words) %>% mutate(cumfreq = cumsum(freq))
# nw_words <- nw_words %>% mutate(freq = n / total_nw_words) %>% mutate(cumfreq = cumsum(freq))


# combine all sources
# all_data <- bind_rows(mutate(tw_text, source = "tw"),mutate(bl_text, source = "bl"), mutate(nw_text, source = "nw"))
# replace line number
# all_data <- all_data %>% mutate(line = 1:(length(twitter_data) + length(blogs_data) + length(news_data)))

# tokenize into words
# all_words <- all_data %>% unnest_tokens(word, text) %>%anti_join(stop_words) %>% count(word, sort = TRUE)

# count number of words
# total_all_words <- sum(all_words$n)

# add frequency and cumulated frequency
# all_words <- all_words %>% mutate(freq = n / total_all_words) %>% mutate(cumfreq = cumsum(freq))

