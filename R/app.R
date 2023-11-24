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
  trip_user <- trips %>% dplyr::select(UUID, ANVID, MALART, FANGOMR)
  catches <- sporegr::read_fangst_clean() %>%
    dplyr::left_join(trip_user, by = "UUID")

  ### Define UI for application that draws a histogram ----------------------------------------------
  ui <- shiny::fluidPage(

    # Application title
    shiny::titlePanel(paste0("Spöreg data explorer. Data folder: ", root)),

    # Sidebar with a slider input for number of bins
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::selectInput("Year", shiny::h3("Year:"),
                    choices = as.list(years), selected = 1),
        shiny::selectInput("User", shiny::h3("User:"),
                    choices = as.list(username), selected = 1)        ),

      # Show a plot of the generated distribution
      shiny::mainPanel(
        shiny::tabsetPanel(
          shiny::tabPanel("Trips",
                          shiny::tableOutput("user_table")),
          shiny::tabPanel("Catch",
                          shiny::tableOutput("catch"))

        )
      )
    )
  )

  ### Define server logic -------------------------
  server <- function(input, output) {
    output$user_table <- shiny::renderTable({
      user_trips <- trips %>%
        dplyr::filter(ANVID == input$User, Year == input$Year) %>%
        dplyr::mutate(RESEDATUM = as.character(RESEDATUM),
                      ANTALPERSONER = as.integer(ANTALPERSONER)) %>%
        dplyr::select(ANVID, NAMN, RESEDATUM, ANTALPERSONER, MALART, FANGOMR)
      user_trips
    })
  output$catch <- shiny::renderTable({
    catch_table <- catches %>%
      dplyr::filter(ANVID == input$User, Year == input$Year) %>%
      dplyr::group_by(ARTBEST, FANGOMR) %>%
      dplyr::summarise(Antal = dplyr::n(), L_max = max(LANGD))
    catch_table
    })
  }
  ### Run the app
  shiny::shinyApp(ui, server)
}
