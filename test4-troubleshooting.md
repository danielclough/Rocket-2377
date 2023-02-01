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

`value: None, kind: InvalidLength` feels like a bad way to report an error.
How can `None` have an `InvalidLength` of `1048576`?
