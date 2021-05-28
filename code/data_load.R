# result:
# train = 1/shrinkage % randomly selected sentences from twitter, blogs, and news data
# test = same as above but without sentences in train

library(tidyverse)

shrinkage <- 100

setwd("~/Coursera/Scripts and Data/Capstone")
data_dir <- file.path(getwd(), "datasets", "final", "en_US")
tw_file_name <- "en_US.twitter.txt"
#bl_file_name <- "en_US.blogs.txt"
#nw_file_name <- "en_US.news.txt"

twitter_data <-
        read_lines(paste0(data_dir, "/", tw_file_name), skip_empty_rows = TRUE)
#blogs_data <-
#        read_lines(paste0(data_dir, "/", bl_file_name), skip_empty_rows = TRUE)
#news_data <-
#        read_lines(paste0(data_dir, "/", nw_file_name), skip_empty_rows = TRUE)


## create random row numbers for train and test datasets

set.seed(1000)

# size of raw data
twl <- length(twitter_data)
#bll <- length(blogs_data)
#nwl <- length(news_data)

# draw obseration numbers for train and test sets
tw_train <- as_tibble(runif(n = twl %/% shrinkage, min = 1, max = twl) %/% 1)
tw_test <- as_tibble(runif(n = twl %/% (shrinkage * 5), min = 1, max = twl) %/% 1)
#bl_train <- as_tibble(runif(n = bll %/% shrinkage, min = 1, max = bll) %/% 1)
#bl_test <- as_tibble(runif(n = bll %/% shrinkage, min = 1, max = bll) %/% 1)
#nw_train <- as_tibble(runif(n = nwl %/% shrinkage, min = 1, max = nwl) %/% 1)
#nw_test <- as_tibble(runif(n = nwl %/% shrinkage, min = 1, max = nwl) %/% 1)

# remove observation numbers contained in train sets
tw_test <- tw_test %>% anti_join(tw_train)
#bl_test <- bl_test %>% anti_join(bl_train)
#nw_test <- nw_test %>% anti_join(nw_train)

# convert to tibbles with line numbers
tw_text <- tibble(line = 1:twl, text = twitter_data)
#bl_text <- tibble(line = 1:bll, text = blogs_data)
#nw_text <- tibble(line = 1:nwl, text = news_data)

# pull out rows 
tw_train <- tw_text %>% slice(tw_train$value)
tw_test <- tw_text %>% slice(tw_test$value)
#bl_train <- bl_text %>% slice(bl_train$value)
#bl_test <- bl_text %>% slice(bl_test$value)
#nw_train <- nw_text %>% slice(nw_train$value)
#nw_test <- nw_text %>% slice(nw_test$value)

# convert back to character 
twtest1 <- twtrain1 <- NULL
bltest1 <- bltrain1 <- NULL
nwtest1 <- nwtrain1 <- NULL

for (i in 1:nrow(tw_train)) {
        twtrain1 <- append(twtrain1, twitter_data[tw_train[[i,1]]])
}
for (i in 1:nrow(tw_test)) {
        twtest1 <- append(twtest1, twitter_data[tw_test[[i,1]]])
}
#for (i in 1:nrow(bl_train)) {
#        bltrain1 <- append(bltrain1, blogs_data[bl_train[[i,1]]])
#}
#for (i in 1:nrow(bl_test)) {
#        bltest1 <- append(bltest1, blogs_data[bl_test[[i,1]]])
#}
#for (i in 1:nrow(nw_train)) {
#        nwtrain1 <- append(nwtrain1, news_data[nw_train[[i,1]]])
#}
#for (i in 1:nrow(nw_test)) {
#        nwtest1 <- append(nwtest1, news_data[nw_test[[i,1]]])
#}

train <- test <- NULL

train <- append(twtrain1, bltrain1)
#train <- append(train, nwtrain1)
test <- append(twtest1, bltest1)
#test <- append(test, nwtest1)

# remove large temporary objects from memory
#rm(twitter_data, blogs_data, news_data)
rm(twtrain1, bltrain1, nwtrain1)
rm(twtest1, bltest1, nwtest1)
rm(tw_train, bl_train, nw_train)
rm(tw_test, bl_test, nw_test)
