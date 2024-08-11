let rec pp_value_error ppf = function
  | Yocaml.Data.Validation.Custom _ -> Format.fprintf ppf "<custom-error>"
  | With_message { given; message } ->
      Format.fprintf ppf "<error-with-message: %s> for %s" message given
  | Invalid_shape { expected; given } ->
      Format.fprintf ppf "<error-invalid-shape: %s> for %a" expected
        Yocaml.Data.pp given
  | Invalid_list { errors; given } ->
      Format.fprintf ppf "<error-invalid-list : %a> for %a"
        (Yocaml.Nel.pp (fun ppf (index, err) ->
             Format.fprintf ppf "%02d. %a" index pp_value_error err))
        errors
        (Format.pp_print_list Yocaml.Data.pp)
        given
  | Invalid_record { errors; given } ->
      Format.fprintf ppf "<error-invalid-record %a> for %a"
        (Yocaml.Nel.pp pp_record_error)
        errors Yocaml.Data.pp (Yocaml.Data.record given)

and pp_record_error ppf = function
  | Yocaml.Data.Validation.Missing_field { field } ->
      Format.fprintf ppf "missing field: %s" field
  | Invalid_field { given; field; error } ->
      Format.fprintf ppf "field: %s, %a for %a" field pp_value_error error
        Yocaml.Data.pp given

let print_validated_value pp_ok x =
  print_endline
  @@ Format.asprintf "%a"
       (Format.pp_print_result ~ok:pp_ok ~error:pp_value_error)
       x

let make_member ident url =
  let open Yocaml.Data in
  ( ident,
    record
      [ ("id", string ident); ("main_link", record [ ("url", string url) ]) ] )

let make_chain l =
  let chain, members = List.split l in
  Yocaml.Data.Validation.list_of Gem.Model.Member.validate
    (Yocaml.Data.list members)
  |> Result.map (fun members -> Gem.Model.Chain.init ~chain ~members)

let member_1 = make_member "member-1" "https://xvw.lol"
let member_2 = make_member "member-2" "https://wvx.lol"
let member_3 = make_member "member-3" "https://xxx.lol"
let member_4 = make_member "member-4" "https://vvv.lol"
