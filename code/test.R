library(tidyverse)
library(tidytext)
library(sbo)

setwd("~/Coursera/Scripts and Data/Capstone")
data_dir <- file.path(getwd(), "datasets", "final", "en_US")
tw_file_name <- "en_US.twitter.txt"

con <- file(paste0(data_dir,"/", tw_file_name), "r") 
twitter_data <- readLines(con, 2360148) 
close(con)

twitter_data <- read_lines(paste0(data_dir,"/", tw_file_name),
                           skip_empty_rows = TRUE)

tw_text <- tibble(line = 1:length(twitter_data), text = twitter_data)

tw_words <- tw_text %>%
        unnest_tokens(word, text) %>%
        filter(str_starts(word, "[a-z]") == TRUE)

# remove "words" not starting with a letter
tw_words <- tw_words  %>%
        count(word, sort = TRUE)
               
total_tw_words <- sum(tw_words$n)

tw_words <- tw_words %>%
        mutate(freq = n / total_tw_words) %>%
        mutate(cumfreq = cumsum(freq))



tw <-
        sbo_predictor(
                object = twitter_data,         # dataset
                N = 3,                         # Train a 3-gram model
                dict = target ~ 0.75,          # cover 75% of training corpus
                .preprocess = sbo::preprocess, # Preprocessing transformation
                EOS = ".?!:;",                 # End-Of-Sentence tokens
                lambda = 0.4,                  # Back-off penalization in SBO algorithm
                L = 3L,                        # Number of predictions for input
                filtered = "<UNK>"             # Exclude the <UNK> token from predictions
        )

predict(tw, "in the")

bl <-
        sbo_predictor(
                object = blogs_data,
                N = 3,
                dict = target ~ 0.75,
                .preprocess = sbo::preprocess, 
                EOS = ".?!:;",                 
                lambda = 0.4,
                L = 3L, 
                filtered = "<UNK>" 
        )

set.seed(1000)
evaluation <- eval_sbo_predictor(tw, test = sbo::twitter_test)

evaluation %>% # Accuracy for in-sentence predictions
        filter(true != "<EOS>") %>%
        summarise(accuracy = sum(correct) / n(),
                  uncertainty = sqrt(accuracy * (1 - accuracy) / n())
        )

dict <- sbo_dictionary(corpus = twitter_data, 
                       max_size = 300, 
                       target = 0.6, 
                       .preprocess = preprocess,
                       EOS = ".?!:;")

x <- kgram_freqs_fast(twitter_data, 
                      N = 2, 
                      dict, 
                      erase = "", 
                      lower_case = TRUE, 
                      EOS = "")





