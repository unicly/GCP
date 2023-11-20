# README

Method: Python  & CLI

In this example data is exported from an external Hive into BigQuery.

The Hive table is stored in a bucket on Google Storage.

## Actions made by the script `main.sh`

- Activate API's
- Create a Cloud Storage bucket and upload files
- Create a Hive table with the help of Cloud Dataproc
- Create a dataset and a table on BigQuery
- Load data into BigQuery from the Hive table
- Execute a SQL query on BigQuery
- CLEANUP
    - Delete all the used services
    - Deactivate the API's


## Installation & run
- Execute the script `generate_data.py`
- Execute the file `main.sh`