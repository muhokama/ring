let minimal_length len =
  let open Yocaml.Data.Validation in
  where ~pp:Format.pp_print_string
    ~message:(fun s -> s ^ " should be at least of size " ^ string_of_int len)
    (fun s -> String.length s >= len)

let has_opt x = Yocaml.Data.bool @@ Option.is_some x
let trim_lowercase x = x |> String.trim |> String.lowercase_ascii

module Lang = struct
  type t = Eng | Fra

  let validate =
    let open Yocaml.Data.Validation in
    string $ trim_lowercase & function
    | "fra" -> Ok Fra
    | "eng" -> Ok Eng
    | given -> fail_with ~given "Invalid Lang Value"

  let to_string = function Fra -> "fra" | Eng -> "eng"
  let normalize lang = Yocaml.Data.string @@ to_string lang
  let pp ppf lang = Format.fprintf ppf "%s" @@ to_string lang

  let equal a b =
    match (a, b) with Fra, Fra | Eng, Eng -> true | Fra, _ | Eng, _ -> false
end

module Url = struct
  type scheme = Http | Https | Gemini
  type t = scheme * string

  let scheme_to_string = function
    | Http -> "http"
    | Https -> "https"
    | Gemini -> "gemini"

  let scheme_to_prefix scheme = scheme_to_string scheme ^ "://"
  let invalid_url given = Yocaml.Data.Validation.fail_with ~given "Invalid url"

  let validate_with_scheme scheme given =
    let prefix = scheme_to_prefix scheme in
    if String.starts_with ~prefix given then
      try
        let len = String.length prefix in
        let gln = String.length given in
        let rest = String.sub given len (gln - len) in
        if String.length rest >= 3 then Ok (scheme, rest) else invalid_url given
      with _ -> invalid_url given
    else invalid_url given

  let validate =
    let open Yocaml.Data.Validation in
    string
    & validate_with_scheme Http
      / validate_with_scheme Https
      / validate_with_scheme Gemini

  let equal_scheme a b =
    match (a, b) with
    | Http, Http | Https, Https | Gemini, Gemini -> true
    | Http, _ | Https, _ | Gemini, _ -> false

  let equal (scheme_a, url_a) (scheme_b, url_b) =
    equal_scheme scheme_a scheme_b && String.equal url_a url_b

  let to_string (scheme, url) = scheme_to_prefix scheme ^ url
  let pp ppf url = Format.fprintf ppf "%s" @@ to_string url

  let normalize ((scheme, url) as full_url) =
    let open Yocaml.Data in
    record
      [
        ("url", string @@ to_string full_url);
        ("scheme", string @@ scheme_to_string scheme);
        ("url_without_scheme", string url);
      ]
end

module Link = struct
  type t = string * Lang.t * Url.t

  let validate =
    let open Yocaml.Data.Validation in
    record (fun fields ->
        let+ title = required fields "title" (string & minimal_length 2)
        and+ lang = optional_or fields "lang" ~default:Lang.Eng Lang.validate
        and+ url = required fields "url" Url.validate in
        (title, lang, url))

  let normalize (title, lang, url) =
    let open Yocaml.Data in
    record
      [
        ("title", string title);
        ("lang", Lang.normalize lang);
        ("url", Url.normalize url);
      ]

  let pp ppf (title, lang, url) =
    Format.fprintf ppf "%s, %a, %a" title Lang.pp lang Url.pp url

  let to_string = Format.asprintf "%a" pp

  let equal (title_a, lang_a, url_a) (title_b, lang_b, url_b) =
    String.equal title_a title_b
    && Lang.equal lang_a lang_b
    && Url.equal url_a url_b
end

module Member = struct
  type t = { id : string; bio : string option; has_avatar : bool }

  let entity_name = "Member"
  let neutral = Yocaml.Metadata.required entity_name
  let validate_id = Yocaml.(Data.Validation.(Slug.validate & minimal_length 2))

  let validate =
    let open Yocaml.Data.Validation in
    record (fun fields ->
        let+ id = required fields "id" validate_id
        and+ bio = optional fields "bio" (string & minimal_length 5)
        and+ has_avatar = optional_or fields ~default:false "has_avatar" bool in
        { id; bio; has_avatar })

  let normalize { id; bio; has_avatar } =
    let open Yocaml.Data in
    [
      ("id", string id);
      ("has_bio", has_opt bio);
      ("bio", option string bio);
      ("has_havatar", bool has_avatar);
    ]
end
