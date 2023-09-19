# Import data from CSV files into a BigQuery table

Method: CLI

In this example data is imported to a BigQuery table from 2 different CSV files.

Actions made by the script:
- Activate the BigQuery API
- Create a Google Storage bucket and upload data files
- Create a dataset and a table using a schema
- Insert data into the table
- Show the content in the table
- Delete the Google Storage bucket with its content
- Delete the table and the dataset
- Deactivate the BigQuery API
