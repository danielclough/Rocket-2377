import requests
import os

print("small file")
file_sm = './file-sm.txt'
files = { 'file': open(file_sm, 'rb'), 'name': os.path.basename(file_sm) }
r = requests.post('http://127.0.0.1:8000/upload', files=files)

print("reported size: {}".format(r.json()['fsize']))
print("stat size: {}".format(os.path.getsize(file_sm)))
assert r.json()['fsize'] == os.path.getsize(file_sm), 'different file size'


print("large file")
file_lg = './file-lg.txt'
files = { 'file': open(file_lg, 'rb'), 'name': os.path.basename(file_lg) }
r = requests.post('http://127.0.0.1:8000/upload', files=files)

print("reported size: {}".format(r.text))
print("stat size: {}".format(os.path.getsize(file_lg)))
assert r.text == os.path.getsize(file_lg), 'different file size'