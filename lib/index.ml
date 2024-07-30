type t = { page : Model.Page.t; chain : Chain.t; interests : Model.Link.t list }

let entity_name = "Parge"

let neutral =
  Ok { page = Model.Page.empty; chain = Chain.empty; interests = [] }

let validate =
  let open Yocaml.Data.Validation in
  record (fun fields ->
      let+ page = Model.Page.validate_underlying_page fields
      and+ interests =
        optional_or ~default:[] fields "interests" (list_of Model.Link.validate)
      in
      { page; interests; chain = Chain.empty })

let merge_chain chain =
  Yocaml.Task.lift ~has_dynamic_dependencies:false (fun x -> { x with chain })

let normalize { page; chain; interests } =
  let open Yocaml.Data in
  let len = List.length interests in
  let interests =
    List.mapi
      (fun i link ->
        let sep =
          if i >= len - 1 then "" else if i >= len - 2 then " and " else ", "
        in
        record (("sep", string sep) :: Model.Link.normalize_underlying_link link))
      interests
  in
  let members =
    chain
    |> Chain.to_list
    |> List.map (fun (curr, (pred, succ)) ->
           record
             (("pred", record @@ Model.Member.normalize pred)
             :: ("succ", record @@ Model.Member.normalize succ)
             :: Model.Member.normalize curr))
  in
  Model.Page.normalize page
  @ [
      ("has_interest", bool @@ List.is_empty interests);
      ("interests", list interests);
      ("chain", list members);
    ]
