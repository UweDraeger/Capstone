# predict based on sbo model

library(sbo)
library(kgrams)

p <- sbo_predictor(
        train,
        N = 5,
        dict = target ~ 0.75,
        .preprocess = sbo::preprocess,
        EOS = ".?!:;",
        lambda = 0.4,
        L = 4L
)

evaluation <- eval_sbo_predictor(p, test = test)

evaluation %>% 
        summarise(accuracy = sum(correct)/n(), 
                  uncertainty = sqrt(accuracy * (1 - accuracy) / n()))

# N = 3: accuracy 0.281 uncertainty 0.00219
# N = 4: accuracy 0.280 uncertainty 0.00218
# N = 5: accuracy 0.282 uncertainty 0.00219
# N = 6: accuracy 0.279 uncertainty 0.00218

# shrinkage 10 / 2.5
# N = 4: accuracy 0.328 uncertainty 0.00227
# N = 5: accuracy 0.342 uncertainty 0.00230

# create a prediction table object
t <- sbo_predtable(
        twitter_data,
        N = 5,
        dict = target ~ 1,
        .preprocess = sbo::preprocess,
        EOS = ".?!:;",
        L = 3L
)

#save(t, file = "t5_10.rda")
load("t.rda")
x <- predictor(t)

# predict next word from phrase
predict(x, "baseball series of")

# word list item 927 ("baseball")
head(attributes(x)$dict)
attributes(x)$dict[927]

# table of words in phrase and predictions
head(t[[4]])
t[[4]][2000,1]
t[[4]][2000,2]
t[[4]][2000,3]
t[[4]][2000,4]
t[[4]][2000,5]
t[[4]][2000,6]

attributes(x)$dict[t[[4]][2000,1]]
attributes(x)$dict[t[[4]][2000,2]]
attributes(x)$dict[t[[4]][2000,3]]
attributes(x)$dict[t[[4]][2000,4]]
attributes(x)$dict[t[[4]][2000,5]]
attributes(x)$dict[t[[4]][2000,6]]
