# Import data from CSV files into a BigQuery table with Cloud Functions

Method: CLI

In this example data is imported to a BigQuery table from CSV files that are uploaded to a Google Storage bucket.

The import function is started automatically as soon as a CSV file has been uploded to the bucket.

Actions made by the script:
- Activate the BigQuery API
- Create a Google Storage bucket and upload data files
- Create a dataset and a table using a schema
- Insert data into the table
- Show the content in the table
- Delete the Google Storage bucket with its content
- Delete the table and the dataset
- Deactivate the BigQuery API

## Installation & run
1. Create and configutre a service account that will be used for creating the Cloud Storage bucket and deploy to Cloud Functions.
    - Add the IAM role "Service Usage Admin" to the service account so it can enable/disable API's
2. Modify the files ```constants.json``` and ```constants.sh```
3. Execute ```main.sh```
