import boto3
import os
import botocore

s3_client = boto3.client('s3')
# bucket_output = os.environ.get("bucket_output", "your-default-bucket-name-failed")
# print(f"Bucket output: {bucket_output}") for testing to check if python is actually getting the bucket name from the environment variable or not
BUCKET_NAME = os.environ.get("BUCKET_NAME", "pam-infrastructure-automation-suite-dev-bucket")

file_name = "test_file.txt"

with open(file_name, "w") as f:
    f.write("This is a test file for S3 upload.")

try:
    s3_client.upload_file(file_name, BUCKET_NAME, file_name)
    print(f"File '{file_name}' uploaded to bucket '{BUCKET_NAME}' successfully.")


except botocore.exceptions.ClientError as e:
    print(f"Error uploading file: {e}")

