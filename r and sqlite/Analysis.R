# lets connect to our db and analyse data
library(RSQLite)
library(DBI)
library(dplyr)
library(sqldf)
library(ggplot2)

# connection
con = dbConnect(dbDriver("SQLite"), "mydb.db")

dbListTables(con)

# load all the data
airlines = dbGetQuery(con, "SELECT * FROM airlines")
airports = dbGetQuery(con, "SELECT * FROM airports")
flights = dbGetQuery(con, "SELECT * FROM flights")
iris = dbGetQuery(con, "SELECT * FROM iris")
mtcars = dbGetQuery(con, "SELECT * FROM mtcar")
planes = dbGetQuery(con, "SELECT * FROM planes")
stroke = dbGetQuery(con, "SELECT * FROM stroke")
weather = dbGetQuery(con, "SELECT * FROM weather")

# basic analysis
# how many patients have stroke?
# we will use the stroke data
# method 1
res = dbGetQuery(con, "SELECT COUNT(stroke) AS count FROM stroke WHERE stroke='1'")
res

# method 2
# it is using the stroke we created above
sqldf("SELECT COUNT(stroke) AS count FROM stroke WHERE stroke='1'")

# how many male patients have stroke?
sqldf("SELECT COUNT(stroke) AS count FROM stroke WHERE stroke='1' AND gender='Male'")

dbGetQuery(con, "SELECT COUNT(stroke) AS count FROM stroke 
           WHERE stroke='1' AND gender='Male'")

# adding dplyr
query = tbl(con, 'stroke') %>%
  select(gender, age, stroke) %>%
  filter(gender=="Male")
query

show_query(query)

dbGetQuery(con, "SELECT * FROM (
  SELECT `gender`, `age`, `stroke`
  FROM `stroke`
)
WHERE (`gender` = 'Male') LIMIT 5")

query = tbl(con, 'stroke') %>%
  select(gender, age, stroke) %>%
  group_by(gender, stroke) %>%
  count()
query
show_query(query)

# you can also plot
query %>% 
  as.data.frame() %>%
  mutate(stroke = as.factor(stroke)) %>%
  ggplot(aes(gender, n, fill=stroke)) +
  geom_bar(stat="identity", position = "dodge") +
  theme_bw()
  
# thanks for watching guys.