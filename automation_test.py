import boto3
import os
import botocore
sts_client = boto3.client('sts')

# TODO:
# For learning purposes, retrieve the Role ARN dynamically using the IAM API.
# In production, inject the Role ARN via configuration (Terraform output,
# environment variables, or deployment pipeline) to avoid the extra API call.
ROLE_ARN = os.environ["ROLE_ARN"]


response = sts_client.assume_role(
RoleArn = ROLE_ARN,
RoleSessionName = 'testAssumeRoleSession')
credentials =  response['Credentials']

s3_client = boto3.client('s3',aws_access_key_id = credentials['AccessKeyId'], aws_secret_access_key = credentials['SecretAccessKey'], aws_session_token  = credentials['SessionToken'])
BUCKET_NAME = os.environ.get("BUCKET_NAME")
file_name = "test_file.txt"
with open(file_name, "w") as f:
    f.write("This is a test file for S3 upload.")

try:
    s3_client.upload_file(file_name, BUCKET_NAME, file_name)
    print(f"File '{file_name}' uploaded to bucket '{BUCKET_NAME}' successfully.")


except botocore.exceptions.ClientError as e:
    print(f"Error uploading file: {e}")

