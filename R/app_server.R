#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import dplyr
#' @import DT
#' @import leaflet
#' @import stringr
#'
#' @noRd
app_server <- function(input, output, session) {
  # sketched in Shiny Assistant

  # Reactive filtered data
  filtered_data <- reactive({
    # created via data-raw/participation.r
    data <- participation

    if (input$obereg_filter != "All") {
      data <- filter(data, OBEREG == input$obereg_filter)
    }

    if (input$control_filter != "All") {
      data <- filter(data, CONTROL == input$control_filter)
    }

    data <- filter(data,
                   admin_year >= input$admin_year_filter[1] &
                     admin_year <= input$admin_year_filter[2])

    data
  })

  # reactive summarization
  aggregated_map_data <- reactive({
    data <- filtered_data()

    summarize(data,
              # to reflect some might have multiple names in IPEDS (e.g. college -> uni)
              unitid = unique(unitid),
              name = paste0(unique(INSTNM), collapse = ","),
              # only latest city and state, lat/lon
              city = unique(CITY)[1],
              state = unique(STABBR)[1],
              LONGITUD = unique(LONGITUD)[1],
              LATITUDE = unique(LATITUDE)[1],
              OBEREG = unique(OBEREG)[1],
              CONTROL = unique(CONTROL)[1],
              last_admin = max(admin_year),
              NSSE = n(),
              BCSSE = sum(BCSSE),
              FSSE = sum(FSSE),
              # just module 1 for now might need restructuring
              module1 = paste0(unique(module1label), collapse = ", "),
              # might need conforming if any have multiple spellings
              consortium = paste0(unique(cons_full), collapse = ","),
              .by = unitid) |>
      # tidy module lists
      mutate(module1 = str_replace_all(module1, c("^,\\s*" = "",
                                                  ", , " = ", ",
                                                  ",\\s*$" = "")),
             consortium = str_replace_all(consortium, c("^,\\s*" = "",
                                                        ", , " = ", ",
                                                        ",\\s*$" = ""))
      )
  })


  # Reset filters
  observeEvent(input$reset_filters, {
    updateSelectInput(session, "obereg_filter", selected = "All")
    updateSelectInput(session, "control_filter", selected = "All")
    updateSliderInput(session, "admin_year_filter",
                      value = c(min(participation$admin_year, na.rm = TRUE),
                                max(participation$admin_year, na.rm = TRUE)))
  })

  # Interactive map with points
  output$map <- renderLeaflet({
    # render base map centered on US.

    # Filter out rows with missing coordinates
    #data_with_coords <- data |>
    #  filter(!is.na(LATITUDE) & !is.na(LONGITUD))

    # plot
    leaflet() |>
      #addTiles() |> basic map, but busy with streets etc.
      addProviderTiles(providers$CartoDB.Positron) |>
      setView(lng = -96.5795, lat = 42.8283, zoom = 4)
  })
  # update map based on filters; avoids redrawing map each time
  observe({
    data <- aggregated_map_data() # filtered then aggregated

    leafletProxy("map") |>
      clearMarkers() |>
      addCircleMarkers(
        data = data,
        lng = ~LONGITUD,
        lat = ~LATITUDE,
        radius = 3,
        popup = ~paste(
          "<strong>Institution:</strong>", name, "<br>",
          "<strong>Region:</strong>", OBEREG, "<br>",
          "<strong>Control:</strong>", CONTROL, "<br>",
          "<strong>Last NSSE:</strong>", last_admin, "<br>",
          "<strong>NSSE Administrations:</strong>", NSSE, "<br>",
          "<strong>BCSSE Administrations:</strong>", BCSSE, "<br>",
          "<strong>FSSE Administrations:</strong>", FSSE, "<br>",
          "<strong>Modules:</strong> ", module1, "<br>",
          "<strong>Consortium Participation:</strong>", consortium
        ),
        color = "#002D6D",
        fillOpacity = 0.8,
        stroke = TRUE,
        weight = 1
      )
  })


  # Interactive data table; server = FALSE allows all data not just displayed
  output$table <- renderDT(server = FALSE, {
    datatable(
      filtered_data(),
      extensions = "Buttons",
      options = list(
        dom = 'Bfrtip',
        pageLength = 25,
        scrollX = TRUE,
        searchHighlight = TRUE,
        order = list(list(0, 'asc')),
        buttons = list(
          list(
            extend = "csv",
            text = "Download CSV",
            filename = "NSSE_participation_data",
            exportOptions = list(modifier = list(page = "all"))
          )
        )
      ),
      filter = "none",
      rownames = FALSE,
      class = 'cell-border stripe'
    )
  })

  # Summary statistics.
  # output$summary <- renderPrint({
  #   data <- filtered_data()
  #   cat("Total Records:", nrow(data), "\n\n")
  #   cat("Column Names:\n")
  #   print(names(data))
  #   cat("\nData Structure:\n")
  #   str(data)
  #   cat("\nSummary:\n")
  #   summary(data)
  # })
}


