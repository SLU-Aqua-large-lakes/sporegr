#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#library(shiny)
#library(sporegr)
#' sporegApp
#'
#' Start the sporeg shiny app.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(sporeg)
#' sporegApp()
#' }
sporegApp <- function() {

  root <- sporegr::APEX_options()$root_folder
  trips <- sporegr::read_resa_clean()
  years <- unique(trips$Year)
  names(years) <- years
  users <- sporegr::read_anvlista()
  username <- users$ANV.NAMN
  names(username) <- users$NAMN
  catches <- sporegr::read_fangst_clean()

  ### Define UI for application that draws a histogram ----------------------------------------------
  ui <- fluidPage(

    # Application title
    titlePanel(paste0("Spöreg data explorer. Data folder: ", root)),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        selectInput("Year", h3("Year:"),
                    choices = as.list(years), selected = 1),
        selectInput("User", h3("User:"),
                    choices = as.list(username), selected = 1)        ),

      # Show a plot of the generated distribution
      mainPanel(
        textOutput("selected_var")
      )
    )
  )

  ### Define server logic -------------------------
  server <- function(input, output) {
    output$selected_var <- renderText({
      paste(paste("Year: ", input$Year),
            paste("User: ", input$User))
    })

  }
}
# Run the application
#sporegApp <- shinyApp(ui = ui, server = server)
