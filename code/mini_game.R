#

init_phrase <- "mind your"

phrase <- init_phrase

new_word <- ""
counter <- 0

while(new_word != "<EOS>") { 
        
      next_word <- predict(x, phrase)
      new_word <- next_word[1]
      phrase <- paste(phrase, new_word)
      counter <- counter + 1
            }

print(phrase)
print(paste("number of words added = ", counter - 1))

