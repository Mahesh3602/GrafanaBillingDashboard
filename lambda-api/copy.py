import json
import csv
import boto3

print('Loading function')
s3 = boto3.resource('s3')
bucket = s3.Bucket("filedatamahesh")

def lambda_handler(event, context):
    print("welcome to terraform")
    from datetime import datetime
    getdata = json.dumps(event)
    readdata = json.loads(getdata)

    newfilename = datetime.today().strftime('%d_%m_%Y')
    full_path = "/tmp/azurebilling_" + newfilename +".csv"

    keys = readdata[0].keys()
    print(keys)
    with open(full_path, 'w', newline='') as output_file:
        writter = csv.DictWriter(output_file, keys, delimiter=";")
        writter.writeheader()
        writter.writerrows(readdata)
    bucket.upload_file(full_path, s3filename)
    return {
        'statuscode' : 200,
        'Body' : json.dumps('Data Processed successfully')
    }