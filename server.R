# Loading required libraries
library(shiny)
library(ggplot2)
library(plotly)

# Read the dataset again with column names
weather_data <- read.csv("MetData/dublin-airport.csv", header = TRUE, skip = 25)

# Convert 'date' column to valid date format
weather_data$date <- as.Date(weather_data$date, format = "%d-%b-%Y")

# Define function to get season based on month
get_season <- function(month) {
  if (month %in% c(12, 1, 2)) {
    return("Winter")
  } else if (month %in% c(3, 4, 5)) {
    return("Spring")
  } else if (month %in% c(6, 7, 8)) {
    return("Summer")
  } else {
    return("Autumn")
  }
}

# Add 'season' column to weather_data
weather_data$month <- as.numeric(format(weather_data$date, "%m"))
weather_data$season <- sapply(weather_data$month, get_season)

create_wind_rose <- function(data) {
  # Convert wind speed to numeric and handle non-numeric values
  data$wdsp <- as.numeric(as.character(data$wdsp), na.rm = TRUE)
  
  # Check if there are valid numeric wind speed values
  if (any(is.na(data$wdsp))) {
    return(NULL)  # Return NULL if there are non-numeric or missing values
  }
  
  # Divide wind speed range into 5 parts and assign colors
  wind_speed_breaks <- quantile(data$wdsp, probs = seq(0, 1, 0.2), na.rm = TRUE)
  color_map <- c("red", "orange", "yellow", "green", "blue")
  data$wind_speed_color <- color_map[findInterval(data$wdsp, wind_speed_breaks, all.inside = TRUE) + 1]
  
  # Create wind rose plot using plot_ly
  plot_ly(data, theta = ~ddhm, r = ~wdsp, text = ~paste("Wind Speed (knot):", wdsp),
          type = "barpolar", width = 600, height = 500) %>%
    add_trace(marker = list(color = ~wind_speed_color), name = "Wind Speed (knot)") %>%
    layout(title = list(text = "Wind Information", font = list(size = 14)),
           polar = list(radialaxis = list(title = "Wind Speed (knot)")),
           showlegend = TRUE, 
           legend = list(
             title = list(text = "Trace", font = list(size = 16)),
             x = 0, y = 1.1,
             xanchor = "center", yanchor = "top"
           ),
           xaxis = list(title = "Wind Direction"),
           yaxis = list(title = list(text = "Wind Speed (knot)", font = list(size = 12))),
           font = list(size = 12),
           margin = list(l = 0)  # Adjust the left margin to move the title away from the plot
    )
}


# Define server
server <- function(input, output, session) {
  
  # Reactive function to filter data based on selected year
  filtered_data <- reactive({
    subset(weather_data, format(date, "%Y") == input$year)
  })
  
  # Reactive function to filter wind data based on selected year and season
  filtered_wind_data <- reactive({
    subset(weather_data, format(date, "%Y") == input$wind_year & season == input$wind_season)
  })
  
  # Reactive plot for temperature data
  output$temperature_plot <- renderPlot({
    # Filter data based on selected year
    filtered_data <- filtered_data()
    
    # Create a combined line plot based on the selected temperature type
    if (input$temperature_type == "Both") {
      max_temp <- max(filtered_data$maxtp, na.rm = TRUE)
      min_temp <- min(filtered_data$mintp, na.rm = TRUE)
      
      ggplot(filtered_data, aes(x = date)) +
        geom_line(aes(y = maxtp, color = "Max Temperature"), size = 0.75) +
        geom_line(aes(y = mintp, color = "Min Temperature"), size = 0.75) +
        geom_label(aes(x = date[which.max(maxtp)], y = maxtp[which.max(maxtp)], 
                       label = paste("Max Temp:", max_temp, "C")), color = "red", vjust = 0.3, hjust = 0.3) +
        geom_label(aes(x = date[which.min(mintp)], y = mintp[which.min(mintp)], 
                       label = paste("Min Temp:", min_temp, "C")), color = "blue", vjust = 0.3, hjust = 0.3) +
        labs(title = paste("Maximum and Minimum Air Temperature in Dublin Airport -", input$year),
             x = "Date",
             y = "Temperature (C)",
             color = "Temperature Type") +
        scale_color_manual(values = c("Max Temperature" = "red", "Min Temperature" = "blue")) +
        theme_minimal() +
        theme(plot.title = element_text(size = 15),
              axis.title.x = element_text(size = 14),
              axis.title.y = element_text(size = 14),
              axis.text.x = element_text(size = 12),
              axis.text.y = element_text(size = 12))
    } else {
      ggplot(filtered_data, aes(x = date)) +
        geom_line(aes_string(y = input$temperature_type), 
                  color = ifelse(input$temperature_type == "maxtp", "red", "blue"), size = 0.75) +
        labs(title = paste(input$temperature_type, "in Dublin Airport -", input$year),
             x = "Date",
             y = "Temperature (C)") +
        theme_minimal() +
        theme(plot.title = element_text(size = 15),
              axis.title.x = element_text(size = 14),
              axis.title.y = element_text(size = 14),
              axis.text.x = element_text(size = 12),
              axis.text.y = element_text(size = 12))
    }
  }, height = 500, width = 600)  # Specify the height and width of the plot here
  
  # Reactive wind rose plot
  observeEvent(input$wind_season, {
    # Filter wind data based on selected year and season
    filtered_wind_data <- filtered_wind_data()
    
    # Check if there is wind data available for the selected year and season
    if (nrow(filtered_wind_data) == 0) {
      output$wind_plot <- renderPlotly(NULL)
    } else {
      output$wind_plot <- renderPlotly({
        create_wind_rose(filtered_wind_data)
      })
    }
  })
}
