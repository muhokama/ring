open Yocaml
open Gem.Model
open Util

let%expect_test "validation - 1" =
  let url = "https://xvw.lol" in
  print_validated_value Url.pp @@ Url.validate @@ Data.string url;
  [%expect {| https://xvw.lol |}]

let%expect_test "validation - 2" =
  let url = "http://xvw.lol" in
  print_validated_value Url.pp @@ Url.validate @@ Data.string url;
  [%expect {| http://xvw.lol |}]

let%expect_test "validation - 3" =
  let url = "gemini://xvw.lol" in
  print_validated_value Url.pp @@ Url.validate @@ Data.string url;
  [%expect {| gemini://xvw.lol |}]

let%expect_test "validation - 4" =
  let url = "https://x" in
  print_validated_value Url.pp @@ Url.validate @@ Data.string url;
  [%expect {| <error-with-message: Invalid url> for https://x |}]

let%expect_test "validation - 5" =
  let url = "http://xv" in
  print_validated_value Url.pp @@ Url.validate @@ Data.string url;
  [%expect {| <error-with-message: Invalid url> for http://xv |}]

let%expect_test "validation - 6" =
  let url = "gemini://x" in
  print_validated_value Url.pp @@ Url.validate @@ Data.string url;
  [%expect {| <error-with-message: Invalid url> for gemini://x |}]

let%expect_test "validation - 7" =
  let url = "foo" in
  print_validated_value Url.pp @@ Url.validate @@ Data.string url;
  [%expect {| <error-with-message: Invalid url> for foo |}]

let%expect_test "validation - 8" =
  let url = "foo://bar.baz" in
  print_validated_value Url.pp @@ Url.validate @@ Data.string url;
  [%expect {| <error-with-message: Invalid url> for foo://bar.baz |}]

let%expect_test "normalization - 1" =
  let url = "https://xvw.lol" in
  print_validated_value Data.pp
    (Result.map Url.normalize (Url.validate @@ Data.string url));
  [%expect
    {|
    {"url": "https://xvw.lol", "scheme": "https", "url_without_scheme":
     "xvw.lol"}
    |}]

let%expect_test "normalization - 2" =
  let url = "http://xvw.lol" in
  print_validated_value Data.pp
    (Result.map Url.normalize (Url.validate @@ Data.string url));
  [%expect
    {| {"url": "http://xvw.lol", "scheme": "http", "url_without_scheme": "xvw.lol"} |}]

let%expect_test "normalization - 3" =
  let url = "gemini://xvw.lol" in
  print_validated_value Data.pp
    (Result.map Url.normalize (Url.validate @@ Data.string url));
  [%expect
    {|
    {"url": "gemini://xvw.lol", "scheme": "gemini", "url_without_scheme":
     "xvw.lol"}
    |}]

let%expect_test "normalization - 4" =
  let url = "foo://xvw.lol" in
  print_validated_value Data.pp
    (Result.map Url.normalize (Url.validate @@ Data.string url));
  [%expect {| <error-with-message: Invalid url> for foo://xvw.lol |}]
