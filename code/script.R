library(tidyverse)
library(tidytext)

setwd("~/Coursera/Scripts and Data/Capstone")

data_dir <- file.path(getwd(), "datasets", "final", "en_US")

tw_file_name <- "en_US.twitter.txt"
bl_file_name <- "en_US.blogs.txt"
nw_file_name <- "en_US.news.txt"

twitter_data <-
        read_lines(paste0(data_dir, "/", tw_file_name), skip_empty_rows = TRUE)
tw_text <-
        tibble(line = 1:length(twitter_data), text = twitter_data)
tw_words <- tw_text %>% unnest_tokens(word, text) %>% count(word, sort = TRUE)
total_tw_words <- sum(tw_words$n)
tw_words <- tw_words %>% mutate(freq = n / total_tw_words) %>% mutate(cumfreq = cumsum(freq))
tw_words %>% 
        slice_head(n = 10)  %>%
        mutate(word = reorder(word, freq)) %>%
        ggplot(aes(x = freq, y = word)) +
        geom_col() +
        geom_text(aes(label = paste0("n = ", n)), hjust = 1.2, colour = "white") +
        labs(title = "Twitter: Top 10 words", 
             subtitle = "Full sample", x = "frequency", y = NULL)
tw_2grams <- tw_text %>% 
        unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
        count(bigram, sort = TRUE)
total_tw_2grams <- sum(tw_2grams$n)
tw_2grams <- tw_2grams %>% mutate(freq = n / total_tw_2grams)
tw_2grams %>% slice_head(n = 10)  %>%
        mutate(bigram = reorder(bigram, n)) %>%
        ggplot(aes(x = n, y = bigram)) +
        geom_col() +
        geom_text(aes(label = paste0("freq = ", round(freq, 4))), hjust = 1.2, colour = "white") +
        labs(title = "Twitter: Top 10 bigrams", 
             subtitle = "Full sample", x = "count", y = NULL)
tw_3grams <- tw_text %>% 
        unnest_tokens(trigram, text, token = "ngrams", n = 3) %>% 
        count(trigram, sort = TRUE)
total_tw_3grams <- sum(tw_3grams$n)
tw_3grams <- tw_3grams %>% mutate(freq = n / total_tw_3grams)
tw_3grams %>% slice_head(n = 11) %>% 
        mutate(trigram = reorder(trigram, n)) %>%
        filter(trigram != "NA") %>%
        ggplot(aes(x = n, y = trigram)) +
        geom_col() +
        geom_text(aes(label = paste0("freq = ", round(freq, 5))), hjust = 1.2, colour = "white") +
        labs(title = "Twitter: Top 10 trigrams", 
             subtitle = "Full sample", x = "count", y = NULL)



blogs_data <-
        read_lines(paste0(data_dir, "/", bl_file_name), skip_empty_rows = TRUE)

bl_text <- 
        tibble(line = 1:length(blogs_data), text = blogs_data)
bl_words <- bl_text %>% unnest_tokens(word, text) %>% count(word, sort = TRUE)
total_bl_words <- sum(bl_words$n)
bl_words <- bl_words %>% mutate(freq = n / total_bl_words) %>% mutate(cumfreq = cumsum(freq))
# bl_2grams <- bl_text %>% unnest_tokens(bigram, text, token = "ngrams", n = 2)  %>% count(bigram, sort = TRUE)
# bl_3grams <- bl_text %>% unnest_tokens(trigram, text, token = "ngrams", n = 3)  %>% count(trigram, sort = TRUE)



news_data <-
        read_lines(paste0(data_dir, "/", nw_file_name), skip_empty_rows = TRUE)
nw_text <- 
        tibble(line = 1:length(news_data), text = news_data)
nw_words <- nw_text %>% unnest_tokens(word, text) %>% count(word, sort = TRUE)
# nw_2grams <- nw_text %>% unnest_tokens(bigram, text, token = "ngrams", n = 2)  %>% count(bigram, sort = TRUE)
# nw_3grams <- nw_text %>% unnest_tokens(trigram, text, token = "ngrams", n = 3)  %>% count(trigram, sort = TRUE)
total_nw_words <- sum(nw_words$n)
nw_words <- nw_words %>% mutate(freq = n / total_nw_words) %>% mutate(cumfreq = cumsum(freq))


# mini dataset
set.seed(100)
twm_text <- tibble(line = 1:length(twitter_data), text = twitter_data) %>%
        slice_sample(prop = 0.1)

twm_words <- twm_text %>%
        unnest_tokens(word, text) %>%
        filter(str_starts(word, "[a-z]") == TRUE) %>%
        count(word, sort = TRUE)

total_twm_words <- sum(twm_words$n)

twm_words <- twm_words %>%
        mutate(freq = n / total_twm_words)
twm_words %>% 
        slice_head(n = 10)  %>%
        mutate(word = reorder(word, freq)) %>%
        ggplot(aes(x = freq, y = word)) +
        geom_col() +
        geom_text(aes(label = paste0("n = ", n)), hjust = 1.2, colour = "white") +
        labs(title = "Twitter: Top 10 words", 
             subtitle = "10% sample size", x = "frequency", y = NULL)

twm_2grams <- twm_text %>% 
        unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
        count(bigram, sort = TRUE)
twm_3grams <- twm_text %>% 
        unnest_tokens(trigram, text, token = "ngrams", n = 3) %>% 
        count(trigram, sort = TRUE)

total_twm_2grams <- sum(twm_2grams$n)
total_twm_3grams <- sum(twm_3grams$n)

twm_2grams <- twm_2grams %>% 
        mutate(freq = n / total_twm_2grams)
twm_3grams <- twm_3grams %>% 
        mutate(freq = n / total_twm_3grams)

twm_2grams %>% slice_head(n = 10)  %>%
        mutate(bigram = reorder(bigram, n)) %>%
        ggplot(aes(x = n, y = bigram)) +
        geom_col() +
        geom_text(aes(label = paste0("freq = ", round(freq, 4))), hjust = 1.2, colour = "white") +
        labs(title = "Twitter: Top 10 bigrams", 
             subtitle = "10% sample size", x = "count", y = NULL)

twm_3grams %>% slice_head(n = 11) %>% 
        mutate(trigram = reorder(trigram, n)) %>%
        filter(trigram != "NA") %>%
        ggplot(aes(x = n, y = trigram)) +
        geom_col() +
        geom_text(aes(label = paste0("freq = ", round(freq, 5))), hjust = 1.2, colour = "white") +
        labs(title = "Twitter: Top 10 trigrams", 
             subtitle = "10% sample size", x = "count", y = NULL)
