open Model_util

type t = string * Lang.t * Url.t

let validate =
  let open Yocaml.Data.Validation in
  record (fun fields ->
      let* url = required fields "url" Url.validate in
      let+ lang = optional_or fields "lang" ~default:Lang.Eng Lang.validate
      and+ title =
        optional_or fields ~default:(Url.url url) "title"
          (string & minimal_length 1)
      in
      (title, lang, url))

let normalize_underlying_link (title, lang, url) =
  let open Yocaml.Data in
  [
    ("title", string title);
    ("lang", Lang.normalize lang);
    ("url", Url.normalize url);
  ]

let normalize link = Yocaml.Data.record (normalize_underlying_link link)

let normalize_to_semantic_list links =
  let open Yocaml.Data in
  let len = List.length links in
  links
  |> List.mapi (fun i link ->
         let sep =
           if i >= len - 1 then "" else if i >= len - 2 then " and " else ", "
         in
         record (normalize_underlying_link link @ [ ("sep", string sep) ]))
  |> list

let pp ppf (title, lang, url) =
  Format.fprintf ppf "%s, %a, %a" title Lang.pp lang Url.pp url

let to_string = Format.asprintf "%a" pp

let equal (title_a, lang_a, url_a) (title_b, lang_b, url_b) =
  String.equal title_a title_b
  && Lang.equal lang_a lang_b
  && Url.equal url_a url_b

let title (title, _, _) = title
let lang (_, lang, _) = lang
let url (_, _, url) = url
