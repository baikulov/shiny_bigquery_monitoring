library(bs4Dash)
# library(echarts4r)
# library(dplyr)
library(bigrquery)
library(DBI)



ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(
        # Input: Select a file ----
        fileInput(
          "file",
          "Выберите файл",
          multiple = FALSE,
          accept = c(".json")
        ),
        actionButton('connect', label = 'Подключиться'),
        uiOutput('bq_projects'),
        uiOutput('bq_datasets'),
        uiOutput('bq_tables'),
        actionButton('upload', label = 'Загрузить'),
        tableOutput('billing')
      )
      
    )
  )
)