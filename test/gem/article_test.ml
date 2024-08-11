open Yocaml
open Gem.Model
open Util

let%expect_test "Validate a minimal article" =
  let article =
    let open Data in
    record
      [
        ("title", string "An Article");
        ("date", string "2024-08-11");
        ("authors", string "xvw");
        ("url", string "https://xvw.lol/a.html");
      ]
  in
  print_validated_value Article.pp (Article.validate article);
  [%expect
    {|
    {"title": "An Article", "synopsis": null, "date":
     {"year": 2024, "month": 8, "day": 11, "hour": 0, "min": 0, "sec": 0,
     "has_time": false, "day_of_week": 6, "repr":
      {"month": "aug", "datetime": "2024-08-11 00:00:00", "date": "2024-08-11",
      "time": "00:00:00", "day_of_week": "sun"}},
    "tags": [], "authors": ["xvw"], "url":
     {"url": "https://xvw.lol/a.html", "scheme": "https", "url_without_scheme":
      "xvw.lol/a.html"}}
    |}]

let%expect_test "Validate a full article" =
  let article =
    let open Data in
    record
      [
        ("title", string "An Article");
        ("date", string "2024-08-11");
        ("authors", list_of string [ "xvw"; "grim" ]);
        ("synopsis", string "A synopsis");
        ("url", string "https://xvw.lol/a.html");
        ("tags", list_of string [ "a"; "b"; "c-d" ]);
      ]
  in
  print_validated_value Article.pp (Article.validate article);
  [%expect
    {|
    {"title": "An Article", "synopsis": "A synopsis", "date":
     {"year": 2024, "month": 8, "day": 11, "hour": 0, "min": 0, "sec": 0,
     "has_time": false, "day_of_week": 6, "repr":
      {"month": "aug", "datetime": "2024-08-11 00:00:00", "date": "2024-08-11",
      "time": "00:00:00", "day_of_week": "sun"}},
    "tags": ["a", "b", "c-d"], "authors": ["xvw", "grim"], "url":
     {"url": "https://xvw.lol/a.html", "scheme": "https", "url_without_scheme":
      "xvw.lol/a.html"}}
    |}]

let%expect_test "Validate an invalid article" =
  let article =
    let open Data in
    record
      [
        ("title", string "An Article");
        ("authors", list_of string [ "xvw"; "grim" ]);
        ("synopsis", string "A synopsis");
        ("tags", list_of string [ "a"; "b"; "c-d" ]);
      ]
  in
  print_validated_value Article.pp (Article.validate article);
  [%expect
    {|
    <error-invalid-record missing field: date
    missing field: url> for {"title": "An Article", "authors": ["xvw", "grim"],
                            "synopsis": "A synopsis", "tags": ["a", "b", "c-d"]}
    |}]
