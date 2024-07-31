let minimal_length len =
  let open Yocaml.Data.Validation in
  where ~pp:Format.pp_print_string
    ~message:(fun s -> s ^ " should be at least of size " ^ string_of_int len)
    (fun s -> String.length s >= len)

let has_opt x = Yocaml.Data.bool @@ Option.is_some x
let has_list x = Yocaml.Data.bool @@ not (List.is_empty x)

let token =
  Yocaml.Data.Validation.(
    string $ fun x -> x |> String.trim |> String.lowercase_ascii)
