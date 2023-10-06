# README

## Install and run the Google BigQuery emulator on a Mac with M1

The BigQuery emulator used is found at https://github.com/goccy/bigquery-emulator. \

The emulator can be installed in two different ways: locally as an application or as a Docker container.

The local installation is well described on the developers GitHub page.\
Instead I will describe here how to use the Docker container.

## Installation & run
Get the Docker container: \
```docker pull ghcr.io/goccy/bigquery-emulator:latest```

Start the container: \
```docker run --platform=linux/x86_64 -it -p 9050:9050 ghcr.io/goccy/bigquery-emulator:latest --project=test-project```
