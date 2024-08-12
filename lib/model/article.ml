open Model_util

type t = {
  title : string;
  synopsis : string option;
  date : Yocaml.Archetype.Datetime.t;
  tags : string list;
  authors : string list;
  link : Link.t;
}

let entity_name = "Article"
let neutral = Yocaml.Metadata.required entity_name

let validate =
  let open Yocaml.Data.Validation in
  record (fun fl ->
      let+ title = required fl "title" string
      and+ synopsis = optional fl "synopsis" string
      and+ date = required fl "date" Yocaml.Archetype.Datetime.validate
      and+ link = required fl "link" Link.validate
      and+ tags =
        optional_or fl ~default:[] "tags" @@ list_of Yocaml.Slug.validate
      and+ authors =
        required fl "authors"
        @@ ((string $ fun x -> [ x ]) / list_of Yocaml.Slug.validate)
      in
      { title; synopsis; date; tags; authors; link })

let authors_in_chain chain { authors; _ } =
  let chain = Chain.to_list chain in
  List.for_all
    (fun author ->
      chain |> List.exists (fun (x, _) -> String.equal author (Member.id x)))
    authors

let normalize { title; synopsis; date; tags; authors; link } =
  let open Yocaml.Data in
  [
    ("title", string title);
    ("has_synopsis", has_opt synopsis);
    ("synopsis", option string synopsis);
    ("date", Yocaml.Archetype.Datetime.normalize date);
    ("tags", list_of string tags);
    ("has_tags", has_list tags);
    ("authors", list_of string authors);
    ("link", Link.normalize link);
  ]

let pp ppf article =
  Format.fprintf ppf "%a" Yocaml.Data.pp
    (article |> normalize |> Yocaml.Data.record)

let sort a b = Yocaml.Archetype.Datetime.compare a.date b.date

let to_atom chain { title; synopsis; date; tags; authors; link } =
  let open Yocaml_syndication in
  let title = title in
  let authors = List.map (Chain.as_author chain) authors in
  let updated = Datetime.make date in
  let categories = List.map Category.make tags in
  let url = link |> Link.url |> Url.to_string in
  let summary = synopsis |> Option.map Atom.text in
  let links = [ Atom.alternate url ~title ] in
  Atom.entry ~authors ~updated ~categories ?summary ~links
    ~title:(Atom.text title) ~id:url ()
