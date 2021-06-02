library(shiny)
library(shinyBS)
library(sbo)

load("t.rda")
p <- predictor(t)

ui <- fluidPage(
        titlePanel("Predictor"),
        
        mainPanel(
                column(
                        12,
                        textAreaInput(
                                inputId = "phrase",
                                label = "Enter your text",
                                value = ""
                        ),
                        helpText("Suggestions in deceasing likelihood")
                ),
                
                # create action buttons
                # and display prediction
                column(
                        4,
                        bsButton("sel_first", 
                                 "append", 
                                 class = "btn-primary", 
                                 block = TRUE
                                 ),
                        verbatimTextOutput(outputId = "first_word")
                ),
                
                column(
                        4,
                        bsButton(inputId = "sel_second",
                                "append",
                                class = "btn-info",
                                block = TRUE
                                ),
                        verbatimTextOutput(outputId = "second_word")
                ),
                
                column(
                        4,
                        bsButton(inputId = "sel_third", 
                                 "append", 
                                 block = TRUE
                                 ),
                        verbatimTextOutput(outputId = "third_word")
                ),
                
                # display current phrase plus prediction
                column(4, textOutput(outputId = "phrase_first")),
                column(4, textOutput(outputId = "phrase_second")),
                column(4, textOutput(outputId = "phrase_third")),
                
                textOutput("text")
        )
)


server <- function(input, output, session) {
        # generate predictions 1:3
        first <- reactive(predict(p, input$phrase)[1])
        second <- reactive(predict(p, input$phrase)[2])
        third <- reactive(predict(p, input$phrase)[3])
        
        # show them
        #        updateActionButton(
        #                session = getDefaultReactiveDomain(),
        #                "sel_first", label = first()
        #        )
        
        output$first_word <- renderText({first()})
        output$second_word <- renderText({second()})
        output$third_word <- renderText({third()})
        
        # new phrase from button pressed
        new_phrase <- reactiveValues(button = NULL)
        
        observeEvent(input$sel_first, {
                updateTextInput(
                        session = getDefaultReactiveDomain(),
                        "phrase",
                        value = paste(input$phrase, first())
                )
        })
        observeEvent(input$sel_second, {
                updateTextInput(
                        session = getDefaultReactiveDomain(),
                        "phrase",
                        value = paste(input$phrase, second())
                )
        })
        observeEvent(input$sel_third, {
                updateTextInput(
                        session = getDefaultReactiveDomain(),
                        "phrase",
                        value = paste(input$phrase, third())
                        )
        })
        
        output$text <- renderText({new_phrase$button})
        
}

shinyApp(ui, server)