open Model_util

type t = { page_title : string option; description : string option }

let entity_name = "Page"
let empty = { page_title = None; description = None }
let neutral = Ok { page_title = None; description = None }

let validate_underlying_page fields =
  let open Yocaml.Data.Validation in
  let+ page_title = optional fields "page_title" string
  and+ description = optional fields "description" string in
  { page_title; description }

let validate = Yocaml.Data.Validation.record validate_underlying_page

let normalize { page_title; description } =
  let open Yocaml.Data in
  [
    ("has_page_title", has_opt page_title);
    ("page_title", option string page_title);
    ("has_description", has_opt description);
    ("description", option string description);
  ]
