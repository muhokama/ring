open Model_util

type t = { page : Page.t; chain : Chain.t; interests : Link.t list }

let entity_name = "Index"
let empty = { page = Page.empty; chain = Chain.empty; interests = [] }
let neutral = Ok empty

let validate =
  let open Yocaml.Data.Validation in
  record (fun fields ->
      let+ page = Page.validate_underlying_page fields
      and+ interests =
        optional_or ~default:[] fields "interests" (list_of Link.validate)
      in
      { page; chain = Chain.empty; interests })

let merge_chain chain =
  Yocaml.Task.lift ~has_dynamic_dependencies:false (fun index ->
      { index with chain })

let normalize { page; chain; interests } =
  let open Yocaml.Data in
  Page.normalize page
  @ [
      ("has_interests", has_list interests);
      ("interests", list_of Link.normalize interests);
      ("has_members", bool (Chain.is_empty chain));
      ("chain", Chain.normalize chain);
    ]
