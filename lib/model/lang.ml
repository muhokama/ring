open Model_util

type t = Eng | Fra

let validate =
  let open Yocaml.Data.Validation in
  token & function
  | "fra" | "fr" -> Ok Fra
  | "eng" | "en" -> Ok Eng
  | given -> fail_with ~given "Invalid Lang Value"

let to_string = function Fra -> "fra" | Eng -> "eng"
let normalize lang = Yocaml.Data.string @@ to_string lang
let pp ppf lang = Format.fprintf ppf "%s" @@ to_string lang

let equal a b =
  match (a, b) with Fra, Fra | Eng, Eng -> true | Fra, _ | Eng, _ -> false
