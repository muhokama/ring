open Yocaml
open Gem.Model
open Util

let mk title ?lang url =
  let open Data in
  record
    [
      ("title", string title); ("lang", option string lang); ("url", string url);
    ]

let%expect_test "validation - 1" =
  let link = mk "Capsule" ~lang:"fra" "https://xvw.lol" in
  print_validated_value Link.pp @@ Link.validate link;
  [%expect {| Capsule, fra, https://xvw.lol |}]

let%expect_test "validation - 2" =
  let link = mk "Capsule" "https://xvw.lol" in
  print_validated_value Link.pp @@ Link.validate link;
  [%expect {| Capsule, eng, https://xvw.lol |}]

let%expect_test "validation - 3" =
  let link = mk "Capsule" "htt://xvw.lol" in
  print_validated_value Link.pp @@ Link.validate link;
  [%expect
    {|
    <error-invalid-record field: url, <error-with-message: Invalid url> for htt://xvw.lol for "htt://xvw.lol"> for
    {"title": "Capsule", "lang": null, "url": "htt://xvw.lol"}
    |}]

let%expect_test "validation - 4" =
  let open Data in
  let link = record [] in
  print_validated_value Link.pp @@ Link.validate link;
  [%expect
    {|
    <error-invalid-record missing field: title
    missing field: url> for {}
    |}]

let%expect_test "normalize - 1" =
  let link = mk "Capsule" ~lang:"fra" "https://xvw.lol" in
  print_validated_value Data.pp
    (link |> Link.validate |> Result.map Link.normalize);
  [%expect
    {|
    {"title": "Capsule", "lang": "fra", "url":
     {"url": "https://xvw.lol", "scheme": "https", "url_without_scheme":
      "xvw.lol"}}
    |}]
