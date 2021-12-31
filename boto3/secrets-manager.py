import boto3
import json
from botocore.exceptions import ClientError


SECRET_ID = ''
REGION = ''

def get_secret(secret_id, region_name):
    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_id)
    except ClientError as e:
        raise e

    secret_json = json.loads(get_secret_value_response['SecretString'])
    return secret_json[secret_id]

get_secret(SECRET_ID, REGION)