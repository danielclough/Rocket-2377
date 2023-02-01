#[macro_use] extern crate rocket;
use rocket::serde::json::Json;
use rocket::fs::TempFile;
use serde::{Serialize, Deserialize};
use rocket::http::ContentType;
use rocket::form::Form;

#[allow(non_snake_case)]
#[derive(FromForm)]
struct FileUpload<'f> {
    name: String,
    file: TempFile<'f>
}

// #[derive(FromForm)]
// struct Test {
//     name: String,
//     file: String
// }

#[derive(Serialize, Deserialize, Debug)]
struct Response {
    name: String,
    fsize: u64
}

#[get("/")]
fn index() -> &'static str {
    "hello, world"
}

#[post("/upload", format = "multipart/form-data", data = "<form>")]
async fn upload(cont_type: &ContentType, form: Form<FileUpload<'_>>) -> Json<Response> {
    println!("Content-Type: {:?}", cont_type);
    println!("file: {:?} size: {:?}", form.name, form.file.len());
    let resp = Response {
        name: form.name.clone(),
        fsize: form.file.len()
    };
    println!("{:?}",resp);
    Json(resp)
}

// #[post("/upload", format = "multipart/form-data", data = "<form>")]
// async fn upload(cont_type: &ContentType, form: Form<Test>) -> Json<Response> {
//     println!("Content-Type: {:?}", cont_type);
//     println!("file: {:?} size: {:?}", form.name, form.file.len());
//     let resp = Response {
//         name: form.name.clone(),
//         fsize: form.file.len() as u64
//     };
//     println!("{:?}",resp);
//     Json(resp)
// }

#[launch]
fn launch() -> _ {
    rocket::build().mount("/", routes![index, upload])
}
