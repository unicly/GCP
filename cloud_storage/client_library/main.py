# https://cloud.google.com/python/docs/reference/storage/latest/google.cloud.storage.bucket.Bucket

import os
from json import load as json_load
from google.cloud import storage

with open('constants.json') as json_data_file:
    const = json_load(json_data_file)

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = const["PATH_CREDENTIALS_FILE"]

def create_bucket(storage_client, bucket_name):
    """Create bucket

    Args:
        storage_client (str): Storage client
        bucket_name (str): Bucket name
    """    
    try:
        bucket = storage_client.bucket(bucket_name)
        bucket.project = const["PROJECT_ID"]
        bucket.storage_class = const["STORAGE_CLASS"]
        bucket.create(location = const["REGION"])

        print(
        "Created bucket {} in {} with storage class {}".format(
                bucket.name, bucket.location, bucket.storage_class
            )
        )

        return bucket
    except Exception as e:
        print(e)


def upload_to_bucket(storage_client, blob_name, file_path, bucket_client, bucket_name):
    """Upload file to bucket

    Args:
        storage_client (str): Storage client
        blog_name (str): Name of the asset to download
        file_path (str): Name of the asset to download
        bucket_client (str): Bucket object
        bucket_name (str): Bucket name
    """

    if bucket_client is None:
        bucket_client = storage_client.bucket(bucket_name)

    blob = bucket_client.blob(blob_name)
    blob.upload_from_filename(file_path)
    return blob


def download_from_bucket(storage_client, blob_name, dest_file_name, bucket_name):
    """Download file by blob name

    Args:
        storage_client (str): Storage client
        blog_name (str): Name of the asset to download
        dest_file_name (str): Save the asset with this name
        bucket_name (str): Bucket name
    """
    bucket = storage_client.get_bucket(bucket_name)
    blob = bucket.blob(blob_name)
    with open(dest_file_name, 'wb') as f:
        storage_client.download_blob_to_file(blob, f)
    print('Saved')


def main():
    storage_client = storage.Client()
    bucket_client = create_bucket(storage_client, const["BUCKET"])

    upload_to_bucket(storage_client, "dog.jpg", "./dog.jpg", bucket_client, const["BUCKET"])
    download_from_bucket(storage_client, "dog.jpg", "dog2.jpg", const["BUCKET"])

if __name__ == "__main__":
    main()