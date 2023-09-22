# R-Shiny-App

## Year: 2023

# Dublin Airport Weather Data Visualization

This Shiny web application allows you to explore and visualize weather data from Dublin Airport. You can view temperature trends and wind information for different years and seasons.

![Dublin Airport](https://alphaflowscreeds.com/wp-content/uploads/2021/02/Dublin-Airport.jpg)

## Features

- Visualize maximum and minimum daily air temperatures recorded at Dublin Airport.
- Choose between viewing Max Temperature, Min Temperature, or both in a single plot.
- Explore wind direction and wind speed data using an interactive wind rose plot.
- Select specific years and seasons for data visualization.

## How to Use

### Running the Shiny App Locally

1. Open R or RStudio on your computer.

2. Install the required R packages if you haven't already. You can install them using the following commands:

   ```R
   install.packages("shiny")
   install.packages("ggplot2")
   install.packages("plotly")
   ```

3. Set your working directory to the folder where you cloned the repository:

   ```R
   setwd("/path/to/your/repo")
   ```

4. Load the Shiny app by running the following commands in R or RStudio:

   ```R
   library(shiny)
   runApp()
   ```

5. Your default web browser should open, and you can interact with the Shiny app.

### Background

The weather data used in this application is sourced from Dublin Airport. It includes daily maximum and minimum air temperatures, as well as wind direction and wind speed information.

### Technologies Used

- Shiny (R package)
- ggplot2 (R package)
- plotly (R package)

## Author 

- **Sarvesh Sairam Naik**
