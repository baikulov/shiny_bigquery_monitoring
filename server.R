library(bs4Dash)
library(echarts4r)
library(dplyr)
library(bigrquery)
library(DBI)
library(RPostgreSQL)

server <- function(input, output) {
  
  # авторизация в bq
  bq_auth(path = 'otus_credentials.json')
  # создаём подключение к БД для выгрузки данных через SQL
  con <- dbConnect(drv = bigquery(),
                   project = "r-studio-280613",
                   dataset = 'Logging')
  
  # текст запроса
  text <- paste0("SELECT * FROM `r-studio-280613.Logging.project_metadata`")
  
  # делаем запрос в БД
  query <-  DBI::dbGetQuery(conn = con, statement = text)
  
  driver <- dbDriver("PostgreSQL")
  
  con2 <- dbConnect(drv=driver,
                   dbname = "shiny",
                   host = "localhost",
                   port = 5432,
                   user = "user1",
                   password = "password1")
  
  # список схем
  #database_list <- dbGetQuery(con, "SELECT datname FROM pg_database;")
  
  # # # список таблиц
  list <- dbGetQuery(con2,"SELECT table_name FROM shiny.information_schema.tables")
  
  # пишем из BQ в POSTGRE
  dbWriteTable(con2, "metadata", query, row.names=FALSE, append=TRUE)
  
  # читаем таблицу для отчета
  metadata <- dbGetQuery(con2, "SELECT * FROM metadata")
  
  output$plot1 <- renderPlot({
    data <- metadata$row_count
    hist(data)
  })
}