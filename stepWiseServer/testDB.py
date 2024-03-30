import psycopg2

#DB Connection
conn = psycopg2.connect(
    dbname="StepWiseServer",
    user="postgres",
    password="Gierath-02",
    host="127.0.0.1",
    port="5432"
)
cur = conn.cursor()
query = "SELECT * FROM Tutorials;"
cur.execute(query)
rows = cur.fetchall()
for row in rows:
    print(row)
cur.close()
conn.close()