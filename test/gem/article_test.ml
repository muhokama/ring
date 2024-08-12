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
        ("link", record [ ("url", string "https://xvw.lol/a.html") ]);
      ]
  in
  print_validated_value Article.pp (Article.validate article);
  [%expect
    {|
    {"title": "An Article", "has_synopsis": false, "synopsis": null, "date":
     {"year": 2024, "month": 8, "day": 11, "hour": 0, "min": 0, "sec": 0,
     "has_time": false, "day_of_week": 6, "repr":
      {"month": "aug", "datetime": "2024-08-11 00:00:00", "date": "2024-08-11",
      "time": "00:00:00", "day_of_week": "sun"}},
    "tags": [], "has_tags": false, "authors": ["xvw"], "link":
     {"title": "xvw.lol/a.html", "lang": "eng", "url":
      {"url": "https://xvw.lol/a.html", "scheme": "https", "url_without_scheme":
       "xvw.lol/a.html"}}}
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
        ("link", record [ ("url", string "https://xvw.lol/a.html") ]);
        ("tags", list_of string [ "a"; "b"; "c-d" ]);
      ]
  in
  print_validated_value Article.pp (Article.validate article);
  [%expect
    {|
    {"title": "An Article", "has_synopsis": true, "synopsis": "A synopsis",
    "date":
     {"year": 2024, "month": 8, "day": 11, "hour": 0, "min": 0, "sec": 0,
     "has_time": false, "day_of_week": 6, "repr":
      {"month": "aug", "datetime": "2024-08-11 00:00:00", "date": "2024-08-11",
      "time": "00:00:00", "day_of_week": "sun"}},
    "tags": ["a", "b", "c-d"], "has_tags": true, "authors": ["xvw", "grim"],
    "link":
     {"title": "xvw.lol/a.html", "lang": "eng", "url":
      {"url": "https://xvw.lol/a.html", "scheme": "https", "url_without_scheme":
       "xvw.lol/a.html"}}}
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
    missing field: link> for {"title": "An Article", "authors": ["xvw", "grim"],
                             "synopsis": "A synopsis", "tags": ["a", "b", "c-d"]}
    |}]
