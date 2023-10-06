#!/bin/bash

bq query \
    --api http://0.0.0.0:9050 \
    --project_id=test-project \
    "SELECT * FROM company.users"

