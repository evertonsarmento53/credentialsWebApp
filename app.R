library("shiny")
library("shinymanager")

# Credentials definition for data security ####
credentials <- data.frame(
    user = c("kroma"), # mandatory
    password = c("pldfinal14"), # mandatory
    #start = c("2019-04-15"), 
    #expire = c(NA, "2019-12-31"),
    admin = c(TRUE),
    comment = "Simple and secure authentification mechanism 
  for single ‘Shiny’ applications.",
    stringsAsFactors = FALSE
)

# Define UI for application that draws a histogram ####
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Wrapping the UI into another secure UI ####
ui <- secure_app(ui)

# Define server logic required to draw a histogram ####
server <- function(input, output, session) {
    
    # call the server part to check credentials .Check_credentials returns a function to authenticate users
    {res_auth <- secure_server(
        check_credentials = check_credentials(credentials)
    )
    output$auth_output <- renderPrint({
        reactiveValuesToList(res_auth)
    })
    }
    
    
    
    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application ####
shinyApp(ui = ui, server = server)
