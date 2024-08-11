open Model_util

type t = {
  page_title : string option;
  description : string option;
  sub_path : string option;
}

let make ?title ?description ?sub_path () =
  { page_title = title; description; sub_path }

let entity_name = "Page"
let empty = make ()
let neutral = Ok empty

let validate_underlying_page fields =
  let open Yocaml.Data.Validation in
  let+ page_title = optional fields "page_title" string
  and+ description = optional fields "description" string
  and+ sub_path = optional fields "sub_path" string in
  { page_title; description; sub_path }

let validate = Yocaml.Data.Validation.record validate_underlying_page

let normalize { page_title; description; sub_path } =
  let open Yocaml.Data in
  [
    ("has_page_title", has_opt page_title);
    ("page_title", option string page_title);
    ("has_description", has_opt description);
    ("description", option string description);
    ("has_sub_path", has_opt sub_path);
    ("sub_path", option string sub_path);
  ]
