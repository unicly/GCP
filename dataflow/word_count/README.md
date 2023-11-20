# README

Method: CLI

In this tiny example words are counted in a text file.

## Actions made by the script `main.sh`
- Activate API's
- Create a Cloud Storage bucket and upload the text file
- Run the Dataflow job
- CLEANUP
    - Delete the bucket
    - Deactivate the API's

## Installation & run
- Download a book in text format from https://www.gutenberg.org/
- Install Apache Beam with `pip install apache_beam[gcp]`
- Execute the file `main.sh`
