#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  # sketched out in Shiny Assistant
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),

    # content layout
    page_sidebar(
      title = "Participation Data Explorer",
      sidebar = sidebar(
        width = 300,
        card(
          card_header("Filters"),
          selectInput(
            "obereg_filter",
            "Region:",
            choices = c("All", levels(participation$OBEREG)),
            selected = "All"
          ),
          selectInput(
            "control_filter",
            "Institutional control:",
            choices = c("All", levels(participation$CONTROL)),
            selected = "All"
          ),
          sliderInput(
            "admin_year_filter",
            "Year Range:",
            min = min(participation$admin_year, na.rm = TRUE),
            max = max(participation$admin_year, na.rm = TRUE),
            value = c(min(participation$admin_year, na.rm = TRUE),
                      max(participation$admin_year, na.rm = TRUE)),
            step = 1,
            sep = ""
          ),
          actionButton("reset_filters", "Reset Filters",
                       class = "btn-secondary w-100")
        )
      ),

      navset_card_tab(
        nav_panel("Map",
                  HTML(c("<h2>A header-2</h2>",
                         "<p>Some explanatory text ina paragraph form.</p>")
                       ),
                  leafletOutput("map", height = "1000px")
        ),
        nav_panel("Data table",
                  DTOutput("table")
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "participationSearch"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
