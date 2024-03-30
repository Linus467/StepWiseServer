import boto3

# Creating a resource object
s3_resource = boto3.resource('s3',
  endpoint_url='http://localhost:9000',
  aws_access_key_id='minioadmin',  # Add your access key
  aws_secret_access_key='minioadmin',  # Add your secret key
  config=boto3.session.Config(signature_version='s3v4')
)

# Example: Accessing a bucket
my_bucket = s3_resource.Bucket('videos')

# Example: Listing objects in a bucket
for my_bucket_object in my_bucket.objects.all():
    print(my_bucket_object.key)
