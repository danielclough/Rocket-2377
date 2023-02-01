import requests
import os
import sys
 
def print_to_stdout(*a):
    print(*a, file=sys.stdout)

# print_to_stdout("small file works fine\n")
file = './file-sm.txt'
files = { 'file': open(file, 'rb'), 'name': os.path.basename(file) }
r = requests.post('http://127.0.0.1:8000/upload', files=files)

print_to_stdout("reported size: {}".format(r.text))
print_to_stdout("stat size: {}".format(os.path.getsize(file)))
assert r.text == os.path.getsize(file), 'different file size'