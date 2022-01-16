library(bs4Dash)
library(echarts4r)
library(dplyr)
library(bigrquery)
library(DBI)



ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(plotOutput("plot1", height = 250))
    )
  )
)