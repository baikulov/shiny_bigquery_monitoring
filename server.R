library(bs4Dash)
library(echarts4r)
library(dplyr)
library(bigrquery)
library(DBI)
library(RPostgreSQL)

server <- function(input, output) {
  
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file)
    
    system("mkdir keys")
    file.copy(input$file$datapath, "keys/key2.json", overwrite = TRUE)
    
    bq_auth(path = "keys/key2.json")
    # создаём подключение к БД для выгрузки данных через SQL
    con <- dbConnect(drv = bigquery(),
                     project = Sys.getenv("BQ_PROJECT"),
                     dataset = Sys.getenv("BQ_DATASET"))  
    
    text <- paste0("SELECT billing_account_id, cost FROM `", Sys.getenv("BQ_PROJECT"),".", Sys.getenv("BQ_DATASET"),".", Sys.getenv("BQ_BILLING_TABLE"), "` LIMIT 10")
    
    query <-  DBI::dbGetQuery(conn = con, statement = text)
    
    })
  
  # reactive({
  #   req(input$file)
  #   #file.copy(input$file$datapath, "key2.json", overwrite = TRUE)
  #   print('hello')
  # })
  
  # reactive({
  #   req(input$file)
  #   print('hello2')
  #   bq_auth(path = "key2.json")
  #   # создаём подключение к БД для выгрузки данных через SQL
  #   con <- dbConnect(drv = bigquery(),
  #                    project = Sys.getenv("BQ_PROJECT"),
  #                    dataset = Sys.getenv("BQ_DATASET"))  
  #   
  #   text <- paste0("SELECT billing_account_id, cost FROM `", Sys.getenv("BQ_PROJECT"),".", Sys.getenv("BQ_DATASET"),".", Sys.getenv("BQ_BILLING_TABLE"), "` LIMIT 100")
  #   
  #   query <-  DBI::dbGetQuery(conn = con, statement = text)
  #   
  # })
  
  
  
  # credentials <- reactive({input$file})
  # 
  # output$txt <- renderText({
  #   tools::file_ext(credentials()$datapath)
  # })
  
  # reactive({
  #   req(input$file)
  #   # # авторизация в bq
  #   bq_auth(path = input$file$datapath)
  #   # создаём подключение к БД для выгрузки данных через SQL
  #   con <- dbConnect(drv = bigquery(),
  #                    project = Sys.getenv("BQ_PROJECT"),
  #                    dataset = Sys.getenv("BQ_DATASET"))  
  #   
  #   text <- paste0("SELECT billing_account_id, cost FROM `", Sys.getenv("BQ_PROJECT"),".", Sys.getenv("BQ_DATASET"),".", Sys.getenv("BQ_BILLING_TABLE"), "` LIMIT 100")
  # })  
  

  # # текст запроса
  
  # 
  # # делаем запрос в БД
  # query <-  DBI::dbGetQuery(conn = con, statement = text)

  # driver <- dbDriver("PostgreSQL")
  # 
  # con2 <- dbConnect(drv=driver,
  #                  dbname = "shiny",
  #                  host = Sys.getenv('DATABASE'),
  #                  port = 5432,
  #                  user = "user1",
  #                  password = "password1")

  # список схем
  #database_list <- dbGetQuery(con, "SELECT datname FROM pg_database;")

  # # # список таблиц
  #list <- dbGetQuery(con2,"SELECT table_name FROM shiny.information_schema.tables")

  # пишем из BQ в POSTGRE
  # dbWriteTable(con2, "metadata2", query, row.names=FALSE, append=TRUE)
  # 
  # # читаем таблицу для отчета
  # metadata <- dbGetQuery(con2, "SELECT * FROM metadata2")

  # output$plot1 <- renderPlot({
  #   data <- metadata$cost
  #   hist(data)
  # })
}