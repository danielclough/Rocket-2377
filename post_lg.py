import requests
import os

print("\n\nlarge file doesn't work\n")
file = './file-lg.txt'
files = { 'file': open(file, 'rb'), 'name': os.path.basename(file) }
r = requests.post('http://127.0.0.1:8000/upload', files=files)

print("reported size: {}".format(r.text))
print("stat size: {}".format(os.path.getsize(file)))
assert r.text == os.path.getsize(file), 'different file size due to response being html'