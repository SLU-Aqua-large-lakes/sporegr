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
#' Browse data from the Spöreg app in several different ways. Input data
#' is read from a predefined location (and filenames) that can be changed with
#' the \code{\link{APEX_options}} function.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(sporeg)
#' # APEX_options(root_folder = "C:/your/folder") # if you have private copies
#' sporegApp()
#' }
sporegApp <- function() {

  root <- sporegr::APEX_options()$root_folder
  trips <- sporegr::read_resa_clean() %>%
    dplyr::mutate(Year = as.integer(Year))
  tripsyears <- unique(trips$Year)
  names(tripsyears) <- tripsyears
  users <- sporegr::read_anvlista()
  username <- users$ANV.NAMN
  names(username) <- users$NAMN
  trip_user <- trips %>% dplyr::select(UUID, ANVID, MALART, FANGOMR)
  catches <- sporegr::read_fangst_clean()
  catches <- fix_fangst_missing_fangstdattid(catches, trips) %>%
    dplyr::left_join(trip_user, by = "UUID")

  ### Define UI for application that draws a histogram ----------------------------------------------
  ui <- shiny::fluidPage(

    # Application title
    shiny::titlePanel(paste0("Spöreg data explorer. Data folder: ", root)),
    shiny::tabsetPanel(
      shiny::tabPanel(
        "Overview",
        # Sidebar with a slider input for number of bins
          shiny::mainPanel(
            shiny::tableOutput(outputId = "Overview1"),
            shiny::tableOutput(outputId = "Overview2")
        )
      ), # End tabpanel "Overview"
      shiny::tabPanel(
        "User",
        # Sidebar with a slider input for number of bins
        shiny::sidebarLayout(
          shiny::sidebarPanel(
            shiny::selectInput(inputId = "Year",
                               shiny::h3("Year:"),
                               choices = as.list(tripsyears), selected = 1),
            shiny::selectInput(inputId = "User",
                               shiny::h3("User:"),
                               choices = as.list(username), selected = 1)),
          # Show a plot of the generated distribution
          shiny::mainPanel(
            shiny::tabsetPanel(
              shiny::tabPanel("Trips",
                              shiny::tableOutput(outputId = "user_table")),
              shiny::tabPanel("Catch",
                              shiny::tableOutput(outputId = "catch")))
          )
        )
      ), # End tabpanel "User"
      shiny::tabPanel(
        "Esquisse",
        esquisse::esquisse_ui(
          id = "esquisse",
          header = FALSE # dont display gadget title
        ),
        tabPanel(
          title = "output",
          tags$b("Code:"),
          verbatimTextOutput("code"),
          tags$b("Filters:"),
          verbatimTextOutput("filters"),
          tags$b("Data:"),
          verbatimTextOutput("data")
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
  output$Overview1 <- shiny::renderTable({
    trips_year_omr <- trips %>%
      dplyr::group_by(Year, FANGOMR) %>%
      dplyr::summarise(N_trips = dplyr::n())
    trips_year_omr
    })
  output$Overview2 <- shiny::renderTable({
    catches_art_omr <- catches %>%
      dplyr::group_by(ARTBEST, FANGOMR) %>%
      dplyr::summarise(N_fish = dplyr::n()) %>%
      dplyr::arrange(dplyr::desc(N_fish))
    catches_art_omr
  })
  results <- esquisse::esquisse_server(
    id = "esquisse",
    data_rv = catches
  )
  output$code <- renderPrint({
    results$code_plot
  })

  output$filters <- renderPrint({
    results$code_filters
  })

  output$data <- renderPrint({
    str(results$data)
  })
  }
  ### Run the app
  shiny::shinyApp(ui, server)
}
