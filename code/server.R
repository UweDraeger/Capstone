library(shiny)
library(sbo)

load("t.rda")
p <- predictor(t)

shinyServer(function(input, output) {
        output$first_word <- renderText(predict(p, input$phrase)[1])
        output$second_word <- renderText(predict(p, input$phrase)[2])
        output$third_word <- renderText(predict(p, input$phrase)[3])

        # initialize predict_from_phrase with input$phrase        
#        predict_from_phrase <- input$phrase
#        new_word <- ""

#        while (new_word != "<EOS>") {
#                next_word <- predict(p, predict_from_phrase[1])
#                new_word <- next_word[1]
#                predict_from_phrase <- paste(predict_from_phrase, new_word)
#        }
        
#        output$phrase_out <- renderText(predict_from_phrase)

})
