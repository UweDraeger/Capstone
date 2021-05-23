library(shiny)

# Define UI 
shinyUI(fluidPage(
        # Application title
        titlePanel("Vorhersage"),
        
        # Sidebar with text input and submit button
        
        sidebarLayout(
                sidebarPanel(
                        textInput(
                                inputId = "phrase",
                                label = "Enter your text",
                                value = ""),
                        submitButton(
                                text = "Go!",
                                icon = ""
                        )
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                        tabsetPanel(
                                tabPanel("Word prediction",
                                         "most likely: ",
                                         verbatimTextOutput(outputId = "first_word"),
                                         "second most likely: ",
                                         verbatimTextOutput(outputId = "second_word"),
                                         "third most likely: ",
                                         verbatimTextOutput(outputId = "third_word")),
                                tabPanel("Mini game",
                                         h2("Enter a phrase of up to 3 words."),
                                         h3("The algorith will predict the next word and add it to your phrase."),
                                         h3("This will be repeated until an End of Sentence character is predicted."),
                                         h3("Goal: Find long and 'sensible' sentences or enjoy the nonsense created."),
                                         textOutput(outputId = "phrase_out"))
                                )
                )
        )
))
