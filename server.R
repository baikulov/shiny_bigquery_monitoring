library(bs4Dash)
library(echarts4r)
library(dplyr)
library(bigrquery)
library(DBI)
library(RPostgreSQL)

server <- function(input, output) {
  
  # авторизация в bq
  bq_auth(path = Sys.getenv("BQ_CREDENTIALS"))
  # создаём подключение к БД для выгрузки данных через SQL
  con <- dbConnect(drv = bigquery(),
                   project = Sys.getenv("BQ_PROJECT"),
                   dataset = Sys.getenv("BQ_DATASET"))
  
  # текст запроса
  text <- paste0("SELECT billing_account_id, cost FROM `", Sys.getenv("BQ_PROJECT"),".", Sys.getenv("BQ_DATASET"),".", Sys.getenv("BQ_BILLING_TABLE"), "` LIMIT 100")
  
  # делаем запрос в БД
  query <-  DBI::dbGetQuery(conn = con, statement = text)
  
  driver <- dbDriver("PostgreSQL")
  
  con2 <- dbConnect(drv=driver,
                   dbname = "shiny",
                   host = Sys.getenv('DATABASE'),
                   port = 5432,
                   user = "user1",
                   password = "password1")
  
  # список схем
  #database_list <- dbGetQuery(con, "SELECT datname FROM pg_database;")
  
  # # # список таблиц
  #list <- dbGetQuery(con2,"SELECT table_name FROM shiny.information_schema.tables")
  
  # пишем из BQ в POSTGRE
  dbWriteTable(con2, "metadata2", query, row.names=FALSE, append=TRUE)
  
  # читаем таблицу для отчета
  metadata <- dbGetQuery(con2, "SELECT * FROM metadata2")
  
  output$plot1 <- renderPlot({
    data <- metadata$cost
    hist(data)
  })
}