library(bs4Dash)
# library(echarts4r)
# library(dplyr)
library(bigrquery)
library(DBI)
library(tidyr)
# library(RPostgreSQL)

server <- function(input, output) {
  
  observeEvent(input$file, {
    file.copy(input$file$datapath, "keys/key2.json", overwrite = TRUE)
  })
  
  
  projects <- reactive({
    req(input$upload)
    bq_auth(path = "keys/key2.json")
    bq_projects()
  })
  
  # UI элементы
  output$bq_projects <- renderUI({
    bq_auth(path = "keys/key2.json")
    selectInput('projects', 'Select project:', selected = NULL, multiple = FALSE, selectize=TRUE, projects())
  })
  
  df <- reactive({
    req(input$projects)
    df <- do.call(rbind.data.frame, bq_project_datasets(input$projects[1]))
  })
  
  

  # UI элементы
  output$bq_datasets <- renderUI({
    bq_auth(path = "keys/key2.json")
    selectInput('datasets', 'Select dataset:', selected = NULL, multiple = FALSE, selectize=TRUE, df()$dataset)
  })
    # bq_projects <-  reactive({
    #   req(input$file)
    #   file.copy(input$file$datapath, "keys/key2.json", overwrite = TRUE)
    #   bq_auth(path = "keys/key2.json")
    #   projects <- bq_projects()
    # })
    # 
    # output$bq_projects <- renderUI({
    #   selectInput('projects', 'Sources:', selected = NULL, multiple = TRUE, selectize=TRUE, bq_projects())
    # })

}