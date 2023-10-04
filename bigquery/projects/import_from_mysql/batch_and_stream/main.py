import csv
import io
import pymysql
from google.cloud import bigquery
from google.cloud import storage
from json import load as json_load

with open('constants.json') as json_data_file:
    const = json_load(json_data_file)


def write_to_local_file(results, column_names):
    """For testing purpose only"""
    csv_file_path = const["OBJECT_NAME"]

    # Open the CSV file for writing.
    with open(csv_file_path, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file)

        # Write the header row.
        header_row = [column for column in column_names]
        writer.writerow(header_row)

        # Write the data rows.
        for row in results:
          writer.writerow(row)   
    
    # Close the CSV file.
    csv_file.close()

    # Print a success message.
    print('Data exported to CSV file successfully!')    


def write_csv_to_memory(results):
    """Create a CSV file in memory.""" 
    csv_data = io.StringIO()
    writer = csv.writer(csv_data)

    # Write the data rows.
    for row in results:
        writer.writerow(row)

    return csv_data.getvalue()


def get_data_from_cloudsql():
    """Export data from Cloud SQL"""
    # Connect to Cloud SQL.
    connection = pymysql.connect(
        host = const["CLOUDSQL_INSTANCE_CONNECTION_NAME"],
        user = const["CLOUDSQL_USER"],
        password = const["CLOUDSQL_PASSWORD"],
        database = const["CLOUDSQL_DB_NAME"]
    )

    # Create a cursor.
    cursor = connection.cursor()

    # Execute a query to get the data from the Cloud SQL table.
    cursor.execute("SELECT * FROM {}.{}".format(const["CLOUDSQL_DB_NAME"], 
                                                const["CLOUDSQL_TABLE_NAME"]))
    # Get the results of the query.
    results = cursor.fetchall()

    cursor.execute(f"DESCRIBE {const['CLOUDSQL_DB_NAME']}.{const['CLOUDSQL_TABLE_NAME']}")
    # Fetch the results
    column_names = [col[0] for col in cursor.fetchall()]    

    return results, column_names


def upload_file_to_bucket(csv_data):
    bucket_name = const["BUCKET"]
    object_name = const["OBJECT_NAME"]

    # Create a GCS client.
    client = storage.Client()

    # Create a bucket object.
    bucket = client.get_bucket(bucket_name)

    # Create a blob object.
    blob = bucket.blob(object_name)

    # Upload the CSV data to the blob.
    blob.upload_from_string(csv_data)


def load_csv_to_bigquery():
    """Batch load data to BigQuery"""

    # Get the Cloud Storage bucket and object name from the event.
    source_uri = f"gs://{const['BUCKET']}/{const['OBJECT_NAME']}"

    client_bq = bigquery.Client()

    # Get the BigQuery table.
    table_ref = client_bq.dataset(const['BIGQUERY_DATASET_ID']).table(const['BIGQUERY_TABLE_NAME'])

    load_job = client_bq.load_table_from_uri(
        source_uri,
        table_ref,
        job_config=bigquery.LoadJobConfig(source_format=bigquery.SourceFormat.CSV),
    )
    load_job.result()

    # Print a success message.
    print('Batch data loaded successfully to BigQuery.')


def stream_insert_bigquery(data):
    """Stream data to BigQuery"""

    # Create a BigQuery client.
    client = bigquery.Client()

    table_ref = client.dataset(const["BIGQUERY_DATASET_ID"]).table(const["BIGQUERY_TABLE_NAME"])
    table = client.get_table(table_ref)
    client.insert_rows(table, data)

    # Print a success message.
    print('Stream data loaded successfully to BigQuery.')



def import_data_to_bigquery():
    results, column_names = get_data_from_cloudsql()
    
    # For testing only
    # write_to_local_file(results, column_names)
    
    csv_data = write_csv_to_memory(results)
    upload_file_to_bucket(csv_data)

    # Batch import into BigQuery
    load_csv_to_bigquery()

    # Stream import into BigQuery
    stream_insert_bigquery(results)


if __name__ == "__main__":
    import_data_to_bigquery()
