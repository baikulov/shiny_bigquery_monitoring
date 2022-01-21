library(bs4Dash)
# library(echarts4r)
# library(dplyr)
library(bigrquery)
library(DBI)
# library(RPostgreSQL)

server <- function(input, output) {
  
  
  # credentials
  observeEvent(input$file, {
    file.copy(input$file$datapath, "keys/key2.json", overwrite = TRUE)
  })
  
  # projects
  projects <- reactive({
    req(input$file)
    req(input$connect)
    bq_auth(path = "keys/key2.json")
    bq_projects()
  })
  
  output$bq_projects <- renderUI({
    selectInput('projects', 'Select project:', selected = NULL, multiple = FALSE, selectize=TRUE, projects())
  })
  
  
  # datasets
  df <- reactive({
    req(input$projects)
    df <- do.call(rbind.data.frame, bq_project_datasets(input$projects))
  })
  
  output$bq_datasets <- renderUI({
    selectInput('datasets', 'Select dataset:', selected = NULL, multiple = FALSE, selectize=TRUE, df()$dataset)
  })
  
  
  # tables
  tbl <- reactive({
    req(input$datasets)
    tbl <- do.call(rbind.data.frame, bq_dataset_tables(paste0(input$projects,".",input$datasets)))
  })

  # UI элементы
  output$bq_tables <- renderUI({
    selectInput('tables', 'Select table:', selected = NULL, multiple = FALSE, selectize=TRUE, tbl()$table)
  })
  
  
  data <- eventReactive(input$upload, {
    bq_table_download(paste0(input$projects, ".", input$datasets, ".", input$tables))        
  })
  
  
  output$billing <- renderTable({
    data()
  })
}