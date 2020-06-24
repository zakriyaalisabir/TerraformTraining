import boto3
s3 = boto3.client('s3')

def handler(event, context):
    # retrieve bucket name and file_key from the S3 event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    # get the object
    obj = s3.get_object(Bucket=bucket_name, Key=file_key)
    # get lines inside the files
    lines = obj['Body'].read().split(b'\n')
    print(lines)
    s3.put_object(Body=lines, Bucket='kk-target', Key='copied/'+file_key)
    return {'status':200,'body':lines}