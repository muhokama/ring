open Yocaml
open Gem.Model
open Util

let mk ?title ?lang url =
  let open Data in
  record
    [
      ("title", option string title);
      ("lang", option string lang);
      ("url", string url);
    ]

let%expect_test "validation - 1" =
  let link = mk ~title:"Capsule" ~lang:"fra" "https://xvw.lol" in
  print_validated_value Link.pp @@ Link.validate link;
  [%expect {| Capsule, fra, https://xvw.lol |}]

let%expect_test "validation - 2" =
  let link = mk "https://xvw.lol" in
  print_validated_value Link.pp @@ Link.validate link;
  [%expect {| xvw.lol, eng, https://xvw.lol |}]

let%expect_test "validation - 3" =
  let link = mk ~title:"Capsule" "htt://xvw.lol" in
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
  [%expect {| <error-invalid-record missing field: url> for {} |}]

let%expect_test "validation - relaying on default title " =
  let link =
    let open Data in
    record [ ("url", string "https://xvw.lol") ]
  in
  print_validated_value Link.pp @@ Link.validate link;
  [%expect {| xvw.lol, eng, https://xvw.lol |}]

let%expect_test "normalize - 1" =
  let link = mk ~title:"Capsule" ~lang:"fra" "https://xvw.lol" in
  print_validated_value Data.pp
    (link |> Link.validate |> Result.map Link.normalize);
  [%expect
    {|
    {"title": "Capsule", "lang": "fra", "url":
     {"url": "https://xvw.lol", "scheme": "https", "url_without_scheme":
      "xvw.lol"}}
    |}]

let%expect_test "normalize to semantic list - 1" =
  let links = Yocaml.Data.list [ mk ~lang:"fra" "https://xvw.lol" ] in
  print_validated_value Data.pp
    (links
    |> Yocaml.Data.Validation.list_of Link.validate
    |> Result.map Link.normalize_to_semantic_list);
  [%expect
    {|
    [{"title": "xvw.lol", "lang": "fra", "url":
      {"url": "https://xvw.lol", "scheme": "https", "url_without_scheme":
       "xvw.lol"},
     "sep": ""}]
    |}]

let%expect_test "normalize to semantic list - 2" =
  let links =
    Yocaml.Data.list
      [ mk ~lang:"fra" "https://xvw.lol"; mk "https://ocaml.org" ]
  in
  print_validated_value Data.pp
    (links
    |> Yocaml.Data.Validation.list_of Link.validate
    |> Result.map Link.normalize_to_semantic_list);
  [%expect
    {|
    [{"title": "xvw.lol", "lang": "fra", "url":
      {"url": "https://xvw.lol", "scheme": "https", "url_without_scheme":
       "xvw.lol"},
     "sep": " and "},
    {"title": "ocaml.org", "lang": "eng", "url":
     {"url": "https://ocaml.org", "scheme": "https", "url_without_scheme":
      "ocaml.org"},
    "sep": ""}]
    |}]

let%expect_test "normalize to semantic list - 3" =
  let links =
    Yocaml.Data.list
      [
        mk ~lang:"fra" "https://xvw.lol";
        mk "https://ocaml.org";
        mk "https://discuss.ocaml.org";
        mk "https://foobar.com";
      ]
  in
  print_validated_value Data.pp
    (links
    |> Yocaml.Data.Validation.list_of Link.validate
    |> Result.map Link.normalize_to_semantic_list);
  [%expect
    {|
    [{"title": "xvw.lol", "lang": "fra", "url":
      {"url": "https://xvw.lol", "scheme": "https", "url_without_scheme":
       "xvw.lol"},
     "sep": ", "},
    {"title": "ocaml.org", "lang": "eng", "url":
     {"url": "https://ocaml.org", "scheme": "https", "url_without_scheme":
      "ocaml.org"},
    "sep": ", "},
    {"title": "discuss.ocaml.org", "lang": "eng", "url":
     {"url": "https://discuss.ocaml.org", "scheme": "https",
     "url_without_scheme": "discuss.ocaml.org"},
    "sep": " and "},
    {"title": "foobar.com", "lang": "eng", "url":
     {"url": "https://foobar.com", "scheme": "https", "url_without_scheme":
      "foobar.com"},
    "sep": ""}]
    |}]
