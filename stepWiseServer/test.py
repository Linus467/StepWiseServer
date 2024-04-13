import boto3
from botocore.config import Config 

s3 = boto3.client('s3',
                endpoint_url= 'http://172.20.10.2:9000',
                aws_access_key_id='5ICyVbHrfPGcuGUMx4Kr',
                aws_secret_access_key='P2YQngwIIfYTuJbbmeBVFAHj9aw4ZAz0IZVZr2Jl',
                region_name='eu-central-1',
                config=Config(signature_version='s3v4')
                )

#testing bucket access
buckets = s3.list_buckets()
for bucket in buckets['Buckets']:
    print(bucket)


