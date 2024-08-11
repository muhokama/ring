type t = {
  title : string;
  synopsis : string option;
  date : Yocaml.Archetype.Datetime.t;
  tags : string list;
  authors : string list;
  url : Url.t;
}

let entity_name = "Article"
let neutral = Yocaml.Metadata.required entity_name

let validate =
  let open Yocaml.Data.Validation in
  record (fun fl ->
      let+ title = required fl "title" string
      and+ synopsis = optional fl "synopsis" string
      and+ date = required fl "date" Yocaml.Archetype.Datetime.validate
      and+ url = required fl "url" Url.validate
      and+ tags =
        optional_or fl ~default:[] "tags" @@ list_of Yocaml.Slug.validate
      and+ authors =
        required fl "authors"
        @@ ((string $ fun x -> [ x ]) / list_of Yocaml.Slug.validate)
      in
      { title; synopsis; date; tags; authors; url })

let authors_in_chain chain { authors; _ } =
  chain
  |> Chain.to_list
  |> List.exists (fun (x, _) ->
         List.exists (String.equal @@ Member.id x) authors)

let normalize { title; synopsis; date; tags; authors; url } =
  let open Yocaml.Data in
  [
    ("title", string title);
    ("synopsis", option string synopsis);
    ("date", Yocaml.Archetype.Datetime.normalize date);
    ("tags", list_of string tags);
    ("authors", list_of string authors);
    ("url", Url.normalize url);
  ]

let pp ppf article =
  Format.fprintf ppf "%a" Yocaml.Data.pp
    (article |> normalize |> Yocaml.Data.record)
