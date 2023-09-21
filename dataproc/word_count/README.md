# README

Method: CLI <a href="https://cloud.google.com/sdk/gcloud/reference/dataproc">link</a>

In this example Python code is executed on a Spark cluster.\
The Python function counts the number of words in a text source (a book in this example).

Steps executed:
- Create a bucket
- Upload files to the bucket
- Create a Spark cluster
- Execute the Python code on the cluster
- Download the result to local folder
- Delete the cluster
- Delete the bucket
