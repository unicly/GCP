from google.api_core.client_options import ClientOptions
from google.auth.credentials import AnonymousCredentials
from google.cloud.bigquery import QueryJobConfig
from google.cloud import bigquery
import pandas as pd


# Create an instance of BigQuery
client_options = ClientOptions(api_endpoint="http://0.0.0.0:9050")
bq_client = bigquery.Client(
  project="test-project",
  client_options=client_options,
  credentials=AnonymousCredentials(),
)

# Convert the data in the CSV to a dataframe
df = pd.read_csv("users.csv")

# Load the dataframe to BigQuery
bq_client.load_table_from_dataframe(df, "company.users")
result = bq_client.query(query="SELECT * FROM company.users", job_config=QueryJobConfig())

for row in result:
    print(row)
