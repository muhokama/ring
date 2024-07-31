open Gem.Model

let make_member ident url =
  let open Yocaml.Data in
  ( ident,
    record
      [ ("id", string ident); ("main_link", record [ ("url", string url) ]) ] )

let m1 = make_member "m1" "https://xvw.lol"
let m2 = make_member "m2" "https://wvx.lol"
let m3 = make_member "m3" "https://xxx.lol"
let m4 = make_member "m4" "https://vvv.lol"

let make l =
  let chain, members = List.split l in
  Yocaml.Data.Validation.list_of Member.validate (Yocaml.Data.list members)
  |> Result.map (fun members -> (chain, members))

let from_list list =
  make list
  |> Result.map (fun (chain, members) ->
         Chain.init ~chain ~members
         |> Chain.fold
              (fun acc ~pred ~curr ~succ ->
                Format.asprintf "%s\n%s [< %s | %s >]" acc (Member.id curr)
                  (Member.id pred) (Member.id succ))
              "")

let%expect_test "Test with a regular chain" =
  let ctx = from_list [ m1; m2; m3; m4 ] in
  Util.print_validated_value Format.pp_print_string ctx;
  [%expect
    {|
    m1 [< m4 | m2 >]
    m2 [< m1 | m3 >]
    m3 [< m2 | m4 >]
    m4 [< m3 | m1 >]
    |}]

let%expect_test "Test with an empty chain" =
  let ctx = from_list [] in
  Util.print_validated_value Format.pp_print_string ctx;
  [%expect {| |}]

let%expect_test "Test with an 1-element chain" =
  let ctx = from_list [ m1 ] in
  Util.print_validated_value Format.pp_print_string ctx;
  [%expect {| m1 [< m1 | m1 >] |}]

let%expect_test "Test with an 2-element chain" =
  let ctx = from_list [ m1; m2 ] in
  Util.print_validated_value Format.pp_print_string ctx;
  [%expect {|
    m1 [< m2 | m2 >]
    m2 [< m1 | m1 >]
    |}]
