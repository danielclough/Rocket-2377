## Experiement 1

Why do these `curl` and `python-requests` POSTs of the same file fail for different reasons?

```rs
POST /upload multipart/form-data:
   >> Matched: (upload) POST /upload multipart/form-data
   >> Data guard `Form < FileUpload < '_ > >` failed: Errors([Error { name: Some("name"), value: None, kind: Missing, entity: Field }, Error { name: Some("file"), value: None, kind: Missing, entity: Field }]).
   >> Outcome: Failure
   >> No 422 catcher registered. Using Rocket default.
   >> Response succeeded.
POST /upload multipart/form-data:
   >> Matched: (upload) POST /upload multipart/form-data
   >> Data guard `Form < FileUpload < '_ > >` failed: Errors([Error { name: Some("name"), value: None, kind: Missing, entity: Field }, Error { name: Some("file"), value: None, kind: InvalidLength { min: None, max: Some(1048576) }, entity: Value }]).
   >> Outcome: Failure
   >> No 422 catcher registered. Using Rocket default.
   >> Response succeeded.
```

The goal was to get the same error, which I accomplished by adding a `Rocket.toml`:
```
[global.limits]
form = 999999
```

```
POST /upload multipart/form-data:
   >> Matched: (upload) POST /upload multipart/form-data
   >> Data guard `Form < Test >` failed: Errors([Error { name: Some("name"), value: None, kind: Missing, entity: Field }, Error { name: Some("file"), value: None, kind: Missing, entity: Field }]).
   >> Outcome: Failure
   >> No 422 catcher registered. Using Rocket default.
   >> Response succeeded.
POST /upload multipart/form-data:
   >> Matched: (upload) POST /upload multipart/form-data
   >> Data guard `Form < Test >` failed: Errors([Error { name: Some("name"), value: None, kind: Missing, entity: Field }, Error { name: Some("file"), value: None, kind: InvalidLength { min: None, max: Some(8192) }, entity: Value }]).
   >> Outcome: Failure
   >> No 422 catcher registered. Using Rocket default.
   >> Response succeeded.
```

But, unexpectadly, `file-xs.txt` now fails differently, with a max of `8192` for the `curl`.

```rs
POST /upload multipart/form-data:
   >> Matched: (upload) POST /upload multipart/form-data
Content-Type: ContentType(MediaType { source: Custom("multipart/form-data; boundary=db27ad9b8c0f9a042d29403698ee04ff"), top: (0, 9), sub: (10, 19), params: Dynamic([((21, 29), (30, 62))]) })
file: "file-xs.txt" size: 954715
Response { name: "file-xs.txt", fsize: 954715 }
   >> Outcome: Success
   >> Response succeeded.
POST /upload multipart/form-data:
   >> Matched: (upload) POST /upload multipart/form-data
   >> Data guard `Form < Test >` failed: Errors([Error { name: Some("file"), value: None, kind: InvalidLength { min: None, max: Some(8192) }, entity: Value }]).
   >> Outcome: Failure
   >> No 413 catcher registered. Using Rocket default.
   >> Response succeeded.
```