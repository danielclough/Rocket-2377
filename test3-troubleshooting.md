## Experiement 1

I changed the struct to test if String would make a difference to how things are parsed.

```rs
#[allow(non_snake_case)]
// #[derive(FromForm)]
// struct FileUpload<'f> {
//     name: String,
//     file: TempFile<'f>
// }

#[derive(FromForm)]
struct Test {
    name: String,
    file: String
}
```

No Change.