library(shiny)

# Define UI 
shinyUI(fluidPage(
        # Application title
        titlePanel("Vorhersage"),
        
        # Sidebar with text input and submt button
        
        sidebarLayout(
                sidebarPanel(
                        textInput(
                                inputId = "phrase",
                                label = "Geben Sie Ihren Text ein",
                                value = ""),
                        submitButton(
                                text = "Los!",
                                icon = ""
                        )
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                        verbatimTextOutput(outputId = "next_word")
                )
        )
))
