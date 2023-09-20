import jwt # The library is PyJWT and not jwt
import time
import os
import requests
import json

with open('constants.json') as json_data_file:
    const = json.load(json_data_file)

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = const["PATH_CREDENTIALS_FILE"]    

def get_access_token():
    # Load the service account key JSON file
    with open(const["PATH_CREDENTIALS_FILE"]) as f:
        service_account_key = json.load(f)

    # Prepare the JWT payload
    now = int(time.time())
    payload = {
        "iss": service_account_key["client_email"],
        "scope": "https://www.googleapis.com/auth/cloud-platform",
        "aud": "https://www.googleapis.com/oauth2/v4/token",
        "exp": now + 3600,
        "iat": now,
    }

    # Create the signed JWT using RS256 algorithm
    private_key = service_account_key["private_key"].encode()
    encoded_jwt = jwt.encode(payload, private_key, algorithm="RS256")

    # Request an access token from Google Cloud
    response = requests.post(
        "https://www.googleapis.com/oauth2/v4/token",
        data={
            "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
            "assertion": encoded_jwt,
        },
    )

    if response.status_code == 200:
        return response.json()["access_token"]
    else:
        raise Exception("Failed to get access token")


def create_bucket(bucket_name, region, storage_class):
    access_token = get_access_token()
    create_bucket_url = f"https://www.googleapis.com/storage/v1/b?project={const['PROJECT_ID']}"
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json",
    }
    data = {
        "name": bucket_name,
        "location": region,
        "storageClass": storage_class        
    }

    response = requests.post(create_bucket_url, headers=headers, json=data)

    if response.status_code == 200:
        print(f"Bucket '{bucket_name}' created successfully.")
    else:
        print(f"Failed to create bucket '{bucket_name}'. Status code: {response.status_code}")
        print(response.text)


def upload_to_google_cloud_storage(bucket_name, object_name, local_file_path):
    access_token = get_access_token()
    upload_url = f"https://www.googleapis.com/upload/storage/v1/b/{bucket_name}/o?uploadType=media&name={object_name}"
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/octet-stream",
    }

    with open(local_file_path, "rb") as f:
        file_data = f.read()

    response = requests.post(upload_url, headers=headers, data=file_data)

    if response.status_code == 200:
        print(f"File uploaded successfully to gs://{bucket_name}/{object_name}")
    else:
        print(f"Failed to upload file. Status code: {response.status_code}")
        print(response.text)


if __name__ == "__main__":
    create_bucket(const["BUCKET"], const["REGION"], const["STORAGE_CLASS"])
    upload_to_google_cloud_storage(const["BUCKET"], const["ASSET_NAME"], const["ASSET_SOURCE_PATH"])