
## Experiement 1
Executing `post_file.py` trys to POST two files:
    `file-sm.txt (2MB)` and `file-lg.txt (2.1MB)`.
The first works and the second fails.

Stdout from `python3 post_file.py`:
```rs
small file
reported size: 2092209
stat size: 2092209
large file
Traceback (most recent call last):
  File "/home/daniel/git/Rocket-2377/post_file.py", line 19, in <module>
    print("reported size: {}".format(r.json()['fsize']))
  File "/usr/lib/python3/dist-packages/requests/models.py", line 900, in json
    return complexjson.loads(self.text, **kwargs)
  File "/usr/lib/python3.10/json/__init__.py", line 346, in loads
    return _default_decoder.decode(s)
  File "/usr/lib/python3.10/json/decoder.py", line 337, in decode
    obj, end = self.raw_decode(s, idx=_w(s, 0).end())
  File "/usr/lib/python3.10/json/decoder.py", line 355, in raw_decode
    raise JSONDecodeError("Expecting value", s, err.value) from None
json.decoder.JSONDecodeError: Expecting value: line 1 column 1 (char 0)
```

In Rocket's Log:
```rs
POST /upload multipart/form-data:
   >> Matched: (upload) POST /upload multipart/form-data
Content-Type: ContentType(MediaType { source: Custom("multipart/form-data; boundary=c8deca0ab02b6d2195caac176c42f273"), top: (0, 9), sub: (10, 19), params: Dynamic([((21, 29), (30, 62))]) })
file: "file-sm.txt" size: 2092209
   >> Outcome: Success
   >> Response succeeded.

POST /upload multipart/form-data:
   >> Matched: (upload) POST /upload multipart/form-data
   >> Data guard `Form < FileUpload < '_ > >` failed: Errors([Error { name: Some("name"), value: None, kind: Missing, entity: Field }, Error { name: Some("file"), value: None, kind: Missing, entity: Field }]).
   >> Outcome: Failure
   >> No 422 catcher registered. Using Rocket default.
   >> Response succeeded.
```

```rs
POST /upload multipart/form-data:
   >> Matched: (upload) POST /upload multipart/form-data
   >> Data guard `Form < FileUpload < '_ > >` failed: Errors([Error { name: Some("name"), value: None, kind: Missing, entity: Field }, Error { name: Some("file"), value: None, kind: Missing, entity: Field }]).
   >> Outcome: Failure
   >> No 422 catcher registered. Using Rocket default.
   >> Response succeeded.
```

```sh
curl -v -H "Content-Type:multipart/form-data" -F files=file-sm.txt \
  http://127.0.0.1:8000/upload
```
Stdout:
```py
*   Trying 127.0.0.1:8000...
* Connected to 127.0.0.1 (127.0.0.1) port 8000 (#0)
> POST /upload HTTP/1.1
> Host: 127.0.0.1:8000
> User-Agent: curl/7.81.0
> Accept: */*
> Content-Length: 151
> Content-Type: multipart/form-data; boundary=------------------------44d852a6541e1980
> 
* We are completely uploaded and fine
* Mark bundle as not supporting multiuse
< HTTP/1.1 422 Unprocessable Entity
< content-type: text/html; charset=utf-8
< server: Rocket
< x-content-type-options: nosniff
< permissions-policy: interest-cohort=()
< x-frame-options: SAMEORIGIN
< content-length: 444
< date: Tue, 31 Jan 2023 00:52:23 GMT
< 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>422 Unprocessable Entity</title>
</head>
<body align="center">
    <div role="main" align="center">
        <h1>422: Unprocessable Entity</h1>
        <p>The request was well-formed but was unable to be followed due to semantic errors.</p>
        <hr />
    </div>
    <div role="contentinfo" align="center">
        <small>Rocket</small>
    </div>
</body>
* Connection #0 to host 127.0.0.1 left intact
```

## Experiement 2

I started to try to find the file size at which things broke, but it is not consistant.

`post_file.py` reports:
```py
small file
reported size: 2079868
stat size: 2079868
```

Bash Reports:
`2097506 Jan 30 17:20 file-sm.txt`

Sometimes these discrepancies are much larger.

Running `post_file.py` again fails with new error (no changes in code):
```py
Traceback (most recent call last):
  File "/home/daniel/git/Rocket-2377/post_file.py", line 9, in <module>
    print("reported size: {}".format(r.json()['fsize']))
  File "/usr/lib/python3/dist-packages/requests/models.py", line 900, in json
    return complexjson.loads(self.text, **kwargs)
  File "/usr/lib/python3.10/json/__init__.py", line 346, in loads
    return _default_decoder.decode(s)
  File "/usr/lib/python3.10/json/decoder.py", line 337, in decode
    obj, end = self.raw_decode(s, idx=_w(s, 0).end())
  File "/usr/lib/python3.10/json/decoder.py", line 355, in raw_decode
    raise JSONDecodeError("Expecting value", s, err.value) from None
json.decoder.JSONDecodeError: Expecting value: line 1 column 1 (char 0)
```

Rocket's Log is the same as for the failures above.

Deleting a little more of the file allows it to work again.

Although the file is smaller this time the size is reported as the (larger) correct size:
```py
reported size: 2093182
stat size: 2093182
```

Bash Reports:
`2093182 Jan 30 17:29 file-sm.txt`

It works several times in a row at that size, adding half of what I deleted and I get:
```py
reported size: 2079868
stat size: 2094777
```

Bash Reports:
`2094777 Jan 30 17:33 file-sm.txt`

After running again with no changes:
```py
reported size: 2094777
stat size: 2094777
```

Going back to the previous file size:
```py
reported size: 1672213
stat size: 1672213
```
Bash Reports:
`2093182 Jan 30 17:38 file-sm.txt`

Running again with no changes reports correct size:
```py
reported size: 2093182
stat size: 2093182
```

## Experiment 3

I started to realize that file size can't be the only cause, so I tried making `file-lg.txt` and `file-sm.txt` the same size.

I am also including the log which shows that I'm getting the same error from curl and the py script.

```rs
python3 post_file.py 
small file
reported size: 2096373
stat size: 2096373

large file
reported size: {"name":"file-lg.txt","fsize":2096373}
stat size: 2096373
Traceback (most recent call last):
  File "/home/daniel/git/Rocket-2377/post_file.py", line 21, in <module>
    assert r.text == os.path.getsize(file_lg), 'different file size'
AssertionError: different file size

daniel@seattle:~/git/Rocket-2377$ ll
...
-rw-rw-r--  1 daniel daniel 2096373 Jan 30 18:22 file-lg.txt
-rw-rw-r--  1 daniel daniel 2096373 Jan 30 18:21 file-sm.txt
```