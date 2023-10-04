# README

Method: Python client library & CLI

In this example data is exported from a MySQL database on CloudSQL and inserted to BigQuery.

Two methods are used:
- Batch
- Stream

For accessing the MySQL database on Cloud SQL with a GUI tool on local machine, the machines IP address must authorised. \
Add the machines IP by clicking on "Add network" on the following page https://cloud.google.com/sql/docs/mysql/configure-ip

## Installation & run
- Give read&write permissions to the Cloud SQL service account to the bucket where the CSV is exported
- Execute the file ```setup.sh```


<img src="diagram.png"></img>