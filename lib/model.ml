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
