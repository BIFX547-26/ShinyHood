library(shiny)
library(bslib)
library(DT)

# Load course data
courses <- read.csv("data/courses.csv", stringsAsFactors = FALSE)

# Columns shown in the browse table
TABLE_COLS <- c("course_number", "course_name", "last_taught", "next_planned")
TABLE_HEADERS <- c("Course #", "Course Name", "Last Taught", "Next Planned")

# Build a filtered reactive and table for one program tab
course_table_ui <- function(id) {
  ns <- NS(id)
  tagList(
    radioButtons(
      ns("type_filter"),
      label = NULL,
      choices = c("All", "Required", "Elective"),
      selected = "All",
      inline = TRUE
    ),
    DTOutput(ns("table"))
  )
}

course_table_server <- function(id, required_col) {
  moduleServer(id, function(input, output, session) {
    # Include courses required for this program (flag == 1) or elective (both flags == 0)
    program_courses <- reactive({
      df <- courses[courses[[required_col]] == 1 |
                      (courses$required_MS == 0 & courses$required_Cert == 0), ]
      df$type <- ifelse(df[[required_col]] == 1, "Required", "Elective")
      df
    })

    filtered <- reactive({
      df <- program_courses()
      if (input$type_filter != "All") {
        df <- df[df$type == input$type_filter, ]
      }
      df
    })

    output$table <- renderDT({
      df <- filtered()[, TABLE_COLS]
      colnames(df) <- TABLE_HEADERS
      datatable(
        df,
        selection = "none",
        rownames = FALSE,
        options = list(
          pageLength = 25,
          dom = "ftp",
          columnDefs = list(list(className = "dt-left", targets = "_all"))
        )
      )
    })

  })
}

# ── UI ────────────────────────────────────────────────────────────────────────

ui <- page_navbar(
  title = "Hood College Bioinformatics Programs",
  theme = bs_theme(
    bootswatch = "cosmo",
    primary = "#003087"   # Hood College navy
  ),
  nav_panel(
    "MS Program",
    card(
      card_header("Master of Science in Bioinformatics"),
      course_table_ui("ms")
    )
  ),
  nav_panel(
    "Graduate Certificate",
    card(
      card_header("Graduate Certificate in Bioinformatics"),
      course_table_ui("cert")
    )
  ),
  nav_spacer(),
  nav_item(
    tags$a(
      "Hood College",
      href = "https://www.hood.edu",
      target = "_blank",
      class = "nav-link"
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────

server <- function(input, output, session) {
  course_table_server("ms",   required_col = "required_MS")
  course_table_server("cert", required_col = "required_Cert")
}

shinyApp(ui, server)
