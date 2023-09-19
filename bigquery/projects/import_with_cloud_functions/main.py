from json import load as json_load
from google.cloud import bigquery

with open('constants.json') as json_data_file:
    const = json_load(json_data_file)


def import_csv_to_bigquery(event=None, context=None):
    """Imports a CSV file to Google BigQuery."""

    # Get the Cloud Storage bucket and object name from the constants file.
    bucket_name = const['BUCKET']
    object_name = const['CSV_FILE']

    # Get the BigQuery dataset and table IDs from the constants file.
    dataset_id = const['DATASET_ID']
    table_name = const['TABLE_NAME']

    # Create a BigQuery client.
    bigquery_client = bigquery.Client()    

    # Create a BigQuery job configuration.
    job_config = bigquery.LoadJobConfig()
    job_config.source_format = bigquery.SourceFormat.CSV
    job_config.skip_leading_rows = 1

    # Load the CSV file to BigQuery.
    load_job = bigquery_client.load_table_from_uri(
        'gs://{}/{}'.format(bucket_name, object_name),
        dataset_id + '.' + table_name,
        job_config = job_config
    )

    # Wait for the job to complete.
    load_job.result()

    # Print a success message.
    print('Successfully imported CSV file to BigQuery.')


if __name__ == '__main__':
    import_csv_to_bigquery()