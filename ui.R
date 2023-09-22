#Loading required libraries
library(shiny)
library(ggplot2)
library(plotly)

# Read the dataset again with column names
weather_data <- read.csv("MetData/dublin-airport.csv", header = TRUE, skip = 25)

# Convert 'date' column to valid date format
weather_data$date <- as.Date(weather_data$date, format = "%d-%b-%Y")

# Define UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      /* Custom CSS for UI */
      body {
        background-image: url('https://alphaflowscreeds.com/wp-content/uploads/2021/02/Dublin-Airport.jpg');
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
        margin: 0;
        padding: 0;
      }
      .widget-box {
        border: 2px solid #007BFF; /* Blue border */
        padding: 10px;
        border-radius: 5px;
        margin-bottom: 15px;
        background-color: transparent; /* Set the background of widgets to transparent */
      }
      .shiny-outputplot {
        background-color: transparent; /* Set plot background to transparent */
      }
    "))
  ),
  titlePanel(
    div(style = "color: #169b62; font-weight: bold; font-size: 28px; text-align: center;",
        "Dublin Airport Weather Data"
    )
  ),
  
  # Temperature plot section
  sidebarLayout(
    sidebarPanel(
      div(class = "widget-box",
          selectInput("temperature_type", "Temperature Data:",
                      choices = c("Max Temperature" = "maxtp", "Min Temperature" = "mintp", "Both")),
          p("Select the type of temperature data you want to visualize:"),
          p("Max Temperature: Shows the maximum daily air temperature recorded at Dublin Airport."),
          p("Min Temperature: Shows the minimum daily air temperature recorded at Dublin Airport."),
          p("Both: Shows both Max and Min Temperature in the same plot.")
      ),
      div(class = "widget-box",
          selectInput("year", "Year:",
                      choices = unique(format(weather_data$date, "%Y"))),
          p("Select the year for which you want to view the temperature data."),
          p("The plot will display the selected temperature data over time.")
      )
    ),
    mainPanel(
      plotOutput("temperature_plot", height = 500, width = 600)
    )
  ),
  
  # Wind rose plot section
  sidebarLayout(
    sidebarPanel(
      div(class = "widget-box",
          selectInput("wind_season", "Season:",
                      choices = c("Winter", "Spring", "Summer", "Autumn")),
          p("Select the season for which you want to view the wind rose plot."),
          p("The wind rose plot visualizes wind direction and speed.")
      ),
      div(class = "widget-box",
          selectInput("wind_year", "Year:",
                      choices = unique(format(weather_data$date, "%Y"))),
          p("Select the year for which you want to view the wind rose plot."),
          p("The plot will display the wind direction and speed data for the selected year and season."),
          p(" Note : If you move the cursor over the plot, you will be able to note the exact windspeed and angle. ")
      )
    ),
    mainPanel(
      plotlyOutput("wind_plot", height = 500, width = 600)
    )
  )
)
