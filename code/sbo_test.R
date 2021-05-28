# build sbo model and tune it

library(sbo)
library(kgrams)


# tuning function
tune <- function(lambda_grid) {
        res <- list(lambda = 0, perplexity = Inf)
        for (lambda in lambda_grid)
        {
                param(model, "lambda") <- lambda
                perplexity <- perplexity(train, model) 
                if (perplexity < res$perplexity)
                        res <- list(lambda = lambda,
                                    perplexity = perplexity)
        }
        return(res)
}

# model definition
model <- language_model(freqs, smoother = "sbo", lambda = 0.5)

# model info
summary(model)
parameters(model)


lambda_grid <- seq(from = 0.0, to = 0.9, by = 0.1)

par <- tune(lambda_grid)
summary(par)
param(model, "lambda") <- par$lambda


p <- sbo_predictor(
        train,
        N = 4,
        dict = target ~ 1,
        .preprocess = sbo::preprocess,
        EOS = ".?!:;",
        lambda = par_sbo$lambda,
        L = 3L
)


evaluation <- eval_sbo_predictor(x, test = test)

evaluation %>% 
        summarise(accuracy = sum(correct)/n(), 
                  uncertainty = sqrt(accuracy * (1 - accuracy) / n()))

# create a prediction table object
t <- sbo_predtable(
        train,
        N = 5,
        dict = target ~ 1,
        .preprocess = sbo::preprocess,
        EOS = ".?!:;",
        L = 3L
)

save(t, file = "t1.rda")
x <- predictor(t)
predict(x," i love")

# https://udraeger.shinyapps.io/Predictor/


shrinkage <- 100

setwd("~/Coursera/Scripts and Data/Capstone")
data_dir <- file.path(getwd(), "datasets", "final", "en_US")
tw_file_name <- "en_US.twitter.txt"
twitter_data <-
        read_lines(paste0(data_dir, "/", tw_file_name), skip_empty_rows = TRUE)

t <- sbo_predtable(
        twitter_data,
        N = 4,
        dict = target ~ 1,
        .preprocess = sbo::preprocess,
        EOS = ".?!:;",
        L = 3L
)

save(t, file = "t1.rda")
 