import pandas as pd
import pymysql

# Conexão com o banco MySQL
conn = pymysql.connect(
    host='localhost',
    user='root',
    password='senha',
    database='Tech4Work'
)

# Consulta principal
query = "SELECT * FROM vw_resumo_vendas"
df_vendas = pd.read_sql(query, conn)

# Exibir
print(df_vendas.head())

conn.close()

df_vendas.to_csv("vw_resumo_vendas.csv", index=False)
