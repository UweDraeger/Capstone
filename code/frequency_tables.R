# result:
# freqs - frequency tables

library(sbo)
library(kgrams)

## preprocess functions for building frequency tables

.preprocess <- function(x) {
        x <- gsub("<[^>]+>", "", x)
        x <- kgrams::preprocess(x)
        return(x)
}

.tknz_sent <- function(x) {
        x <- paste(x, collapse = " ")
        x <- kgrams::tknz_sent(x, keep_first = TRUE)
        x <- x[x != ""]
        return(x)
}

N <- 5

f <- kgram_freqs(object = twitter_data, 
                 N,   
                 .preprocess = .preprocess,
                 .tknz_sent = .tknz_sent
)

query(f,"by the way")
m <- language_model(f,"sbo", lambda = 0.4)

predict(p, "by the way i")[1]
predict(p, "by the way i")[2]
predict(p, "by the way i")[3]
predict(p, "by the way i")[4]

probability("by the way" %|% predict(p, "by the way")[1], m)
probability("by the way" %|% predict(p, "by the way")[2], m)
probability("by the way" %|% predict(p, "by the way")[3], m)
probability("by the way" %|% predict(p, "by the way")[4], m)

