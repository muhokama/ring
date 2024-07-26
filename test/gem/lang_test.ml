open Yocaml
open Gem.Model

let%expect_test "validation - 1" =
  let base = Lang.Eng in
  let epct =
    Data.[ string "eng"; string "Eng"; string "eNg" ] |> List.map Lang.validate
  in
  let result =
    List.for_all
      (fun lang ->
        let lang = Result.get_ok lang in
        Lang.equal base lang)
      epct
  in
  print_endline @@ string_of_bool result;
  [%expect {| true |}]

let%expect_test "validation - 2" =
  let base = Lang.Fra in
  let epct =
    Data.[ string "fra"; string "FrA"; string "fRA" ] |> List.map Lang.validate
  in
  let result =
    List.for_all
      (fun lang ->
        let lang = Result.get_ok lang in
        Lang.equal base lang)
      epct
  in
  print_endline @@ string_of_bool result;
  [%expect {| true |}]

let%expect_test "validation - 3" =
  let epct = Data.string "Far" |> Lang.validate in
  let result = match epct with Ok _ -> "should fail" | Error _ -> "correct" in
  print_endline result;
  [%expect {| correct |}]

let%expect_test "normalization - 1" =
  let result = Lang.Eng |> Lang.normalize in
  print_endline @@ Format.asprintf "%a" Data.pp result;
  [%expect {| "eng" |}]

let%expect_test "normalization - 2" =
  let result = Lang.Fra |> Lang.normalize in
  print_endline @@ Format.asprintf "%a" Data.pp result;
  [%expect {| "fra" |}]
