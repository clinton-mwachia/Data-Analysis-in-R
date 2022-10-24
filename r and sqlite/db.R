# creating the db
library(RSQLite)
library(nycflights13)

head(mtcars)
head(iris)

stroke = readr::read_csv("healthcare-dataset-stroke-data.csv")

# the connection
con = dbConnect(SQLite(), "mydb.db")

# lets add some tables
dbWriteTable(con, "mtcar", mtcars)
dbWriteTable(con, "iris", iris)
dbWriteTable(con, "stroke", stroke)
dbWriteTable(con, "flights", flights)
dbWriteTable(con, "planes", planes)
dbWriteTable(con, "airlines", airlines)
dbWriteTable(con, "airports", airports)
dbWriteTable(con, "weather", weather)

# list tables in db
dbListTables(con)
