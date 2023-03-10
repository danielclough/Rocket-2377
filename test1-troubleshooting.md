## Experiement 1
Executing `post_file.py` trys to POST two files:
    `file-sm.txt (2MB)` and `file-lg.txt (2.1MB)`.
The first works and the second fails.

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

Stdout:
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

> I was not able to reproduce failing at the same size more than once.

I fixed the error to show clearly that I'm getting the same error from curl and `post_file.py`.

```rs
small file
reported size: 2096373
stat size: 2096373

large file
reported size: <!DOCTYPE html>
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
</html>
stat size: 2097506
Traceback (most recent call last):
  File "/home/daniel/git/Rocket-2377/post_file.py", line 21, in <module>
    assert r.text == os.path.getsize(file_lg), 'different file size'
AssertionError: different file size
```


## Docs Investigation 1

I found the reason for the cutoff.

[Built-in Limits](https://api.rocket.rs/v0.5-rc/rocket/data/struct.Limits.html#built-in-limits)

| Limit Name |	Default	| Type |	Description |
|--|--|--|--|
| data-form |	2MiB |	Form |	entire data-based form |
| file |	1MiB	| TempFile |	TempFile data guard or form field |
| json	| 1MiB |	Json	| JSON data and form payloads |

## Experiment 5

```
curl -v -H "Content-Type:multipart/form-data" \
 -F file=@file-sm.txt -F name=file-sm.txt \
 http://127.0.0.1:8000/upload
```

I notice the `InvalidLength` is max 1048576, and curl is sending a length of 2096562.
This is the same file that works when sending with `post_sm.py`.


```rs
POST /upload multipart/form-data:
   >> Matched: (upload) POST /upload multipart/form-data
   >> Data guard `Form < FileUpload < '_ > >` failed: Errors([Error { name: Some("file"), value: None, kind: InvalidLength { min: None, max: Some(1048576) }, entity: Value }]).
   >> Outcome: Failure
   >> No 413 catcher registered. Using Rocket default.
   >> Response succeeded.
```

Trying again with smaller file:
```
curl -v \
 -F file=@file-xs.txt -F name=file-xs.txt \
 http://127.0.0.1:8000/upload
```
```rs
curl -v \
 -F file=@file-xs.txt -F name=file-xs.txt \
 http://127.0.0.1:8000/upload
*   Trying 127.0.0.1:8000...
* Connected to 127.0.0.1 (127.0.0.1) port 8000 (#0)
> POST /upload HTTP/1.1
> Host: 127.0.0.1:8000
> User-Agent: curl/7.81.0
> Accept: */*
> Content-Length: 955008
> Content-Type: multipart/form-data; boundary=------------------------aaae7fd2ba535b2b
> 
* We are completely uploaded and fine
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< content-type: application/json
< server: Rocket
< x-content-type-options: nosniff
< x-frame-options: SAMEORIGIN
< permissions-policy: interest-cohort=()
< content-length: 37
< date: Tue, 31 Jan 2023 06:35:56 GMT
< 
* Connection #0 to host 127.0.0.1 left intact
{"name":"file-xs.txt","fsize":954715}
```

> It works!