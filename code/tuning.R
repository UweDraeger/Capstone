library(tidyverse)
library(sbo)
library(kgrams)


setwd("~/Coursera/Scripts and Data/Capstone")
data_dir <- file.path(getwd(), "datasets", "final", "en_US")
tw_file_name <- "en_US.twitter.txt"
bl_file_name <- "en_US.blogs.txt"
nw_file_name <- "en_US.news.txt"

twitter_data <-
        read_lines(paste0(data_dir, "/", tw_file_name), skip_empty_rows = TRUE)
blogs_data <-
        read_lines(paste0(data_dir, "/", bl_file_name), skip_empty_rows = TRUE)
news_data <-
        read_lines(paste0(data_dir, "/", nw_file_name), skip_empty_rows = TRUE)


## create random row numbers for train and test datasets

set.seed(1000)

# size of raw data
twl <- length(twitter_data)
bll <- length(blogs_data)
nwl <- length(news_data)

# draw obseration numbers for train and test sets
tw_train <- as_tibble(runif(n = twl %/% 100, min = 1, max = twl) %/% 1)
tw_test <- as_tibble(runif(n = twl %/% 100, min = 1, max = twl) %/% 1)
bl_train <- as_tibble(runif(n = bll %/% 100, min = 1, max = bll) %/% 1)
bl_test <- as_tibble(runif(n = bll %/% 100, min = 1, max = bll) %/% 1)
nw_train <- as_tibble(runif(n = nwl %/% 100, min = 1, max = nwl) %/% 1)
nw_test <- as_tibble(runif(n = nwl %/% 100, min = 1, max = nwl) %/% 1)

# remove observation numbers contained in train sets
tw_test <- tw_test %>% anti_join(tw_train)
bl_test <- bl_test %>% anti_join(bl_train)
nw_test <- nw_test %>% anti_join(nw_train)

# convert to tibbles with line numbers
tw_text <- tibble(line = 1:twl, text = twitter_data)
bl_text <- tibble(line = 1:bll, text = twitter_data)
nw_text <- tibble(line = 1:nwl, text = twitter_data)

# pull out rows 
tw_train <- tw_text %>% slice(tw_train$value)
tw_test <- tw_text %>% slice(tw_test$value)
bl_train <- bl_text %>% slice(bl_train$value)
bl_test <- bl_text %>% slice(bl_test$value)
nw_train <- nw_text %>% slice(nw_train$value)
nw_test <- nw_text %>% slice(nw_test$value)

# convert back to character 
twtest1 <- twtrain1 <- NULL
bltest1 <- bltrain1 <- NULL
nwtest1 <- nwtrain1 <- NULL

for (i in 1:nrow(tw_train)) {
        twtrain1 <- append(twtrain1, twitter_data[tw_train[[i]]])
}
for (i in 1:nrow(tw_test)) {
        twtest1 <- append(twtest1, twitter_data[tw_test[[i]]])
}
for (i in 1:nrow(bl_train)) {
        bltrain1 <- append(bltrain1, blogs_data[bl_train[[i]]])
}
for (i in 1:nrow(bl_test)) {
        bltest1 <- append(bltest1, blogs_data[bl_test[[i]]])
}
for (i in 1:nrow(nw_train)) {
        nwtrain1 <- append(nwtrain1, news_data[nw_train[[i]]])
}
for (i in 1:nrow(nw_test)) {
        nwtest1 <- append(nwtest1, news_data[w_test[[i]]])
}

# remove temporary objects
rm(twitter_data)
rm(blogs_data)
rm(news_data)

train <- append(twtrain1, bltrain1)
train <- append(train, nwtrain1)
test <- append(twtest1, bltest1)
test <- append(test, nwtest1)

# train = 1% randomly selected sentences from twitter, blogs, and news data
# test = same as above but without sentences in train



## preprocess functions for building frequency tables


# see https://vgherard.github.io/sbo/reference/preprocess.html
.preprocess <- function(x) {
        # removes everything except alphanum and punctuation
        x <- kgrams::preprocess(x)
        return(x)
}

.tknz_sent <- function(x) {
        # Collapse everything to a single string
        x <- paste(x, collapse = " ")
        # Tokenize sentences
        x <- kgrams::tknz_sent(x, keep_first = FALE)
        # Remove empty sentences
        x <- x[x != ""]
        return(x)
}

# find lambda from lambda_range with min perplexity 
tune_sbo <- function(lambda_range) {
        res <- list(lambda = 0.5, perplexity = Inf)
        for (lambda in lambda_range)
        {
                param(model, "lambda") <- lambda
                perplexity <- perplexity(train, model) 
                if (perplexity < res$perplexity)
                        res <- list(lambda = lambda,
                                    perplexity = perplexity)
        }
        return(res)
}


N <- 5

freqs <- kgram_freqs(train, N, 
                     .preprocess = .preprocess,
                     .tknz_sent = .tknz_sent
                     )

model <- language_model(freqs, smoother = "sbo", lambda = 0.5)
summary(model)

parameters(model)


lambda_grid <- seq(from = 0.0, to = 1, by = 0.1)
par_sbo <- tune_sbo(lambda_grid)
summary(par_sbo)
param(model, "lambda") <- par_sbo$lambda
