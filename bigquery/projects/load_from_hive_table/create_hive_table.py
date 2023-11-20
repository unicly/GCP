from pyspark.sql import SparkSession
import constants as const

"""
This script creates an external Hive table and populates it with data from a CSV file.
The table is created on GCS.
"""

spark = SparkSession.builder \
    .appName("Create Hive Table") \
    .enableHiveSupport() \
    .getOrCreate()

# Read CSV file from GCS
df = spark.read.csv(const.BUCKET_NAME, 
                        header=True,
                        inferSchema=True)

# Define the table location
external_table_location = f"{const.BUCKET_NAME}/hive_tables/{const.HIVE_TABLE_NAME}"

# Create the Hive table and import data from CSV file
df.write.mode("overwrite") \
        .option("path", external_table_location) \
        .saveAsTable(const.HIVE_TABLE_NAME, format="parquet")

spark.stop()
