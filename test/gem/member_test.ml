open Yocaml
open Gem.Model
open Util

let%expect_test "validate a minimal member" =
  let member =
    let open Data in
    record
      [
        ("id", string "xwv");
        ("main_link", record [ ("url", string "https://xvw.lol") ]);
      ]
  in
  print_validated_value Member.pp (Member.validate member);
  [%expect
    {|
    {"id": "xwv", "display_name": "xwv", "has_bio": false, "bio": null,
    "has_avatar": false, "main_link":
     {"title": "xvw.lol", "lang": "eng", "url":
      {"url": "https://xvw.lol", "scheme": "https", "url_without_scheme":
       "xvw.lol"}},
    "has_main_feed": false, "main_feed": null, "has_nouns": false, "nouns":
    [], "has_additional_links": false, "additional_links": [],
    "has_additional_feeds": false, "additional_feeds": [], "has_location":
     false, "location": null}
    |}]

let%expect_test "validate a full member" =
  let member =
    let open Data in
    record
      [
        ("id", string "xwv");
        ("bio", string "I an OCaml programmer from Belgium, living in France");
        ("has_avatar", bool true);
        ("location", string "France, Nantes");
        ("nouns", list_of string [ "he"; "him"; "his"; "himself" ]);
        ("main_link", record [ ("url", string "https://xvw.lol") ]);
        ("main_feed", record [ ("url", string "https://xvw.lol/atom.xml") ]);
        ( "additional_links",
          list
            [
              record [ ("url", string "https://xvw1.lol") ];
              record [ ("url", string "https://xvw2.lol") ];
            ] );
        ( "additional_feeds",
          list
            [
              record [ ("url", string "https://xvw.lol/1.xml") ];
              record [ ("url", string "https://xvw.lol/2.xml") ];
            ] );
      ]
  in
  print_validated_value Member.pp (Member.validate member);
  [%expect
    {|
    {"id": "xwv", "display_name": "xwv", "has_bio": true, "bio":
     "I an OCaml programmer from Belgium, living in France", "has_avatar": true,
    "main_link":
     {"title": "xvw.lol", "lang": "eng", "url":
      {"url": "https://xvw.lol", "scheme": "https", "url_without_scheme":
       "xvw.lol"}},
    "has_main_feed": true, "main_feed":
     {"title": "xvw.lol/atom.xml", "lang": "eng", "url":
      {"url": "https://xvw.lol/atom.xml", "scheme": "https",
      "url_without_scheme": "xvw.lol/atom.xml"}},
    "has_nouns": true, "nouns": ["he", "him", "his", "himself"],
    "has_additional_links": true, "additional_links":
     [{"title": "xvw1.lol", "lang": "eng", "url":
       {"url": "https://xvw1.lol", "scheme": "https", "url_without_scheme":
        "xvw1.lol"}},
     {"title": "xvw2.lol", "lang": "eng", "url":
      {"url": "https://xvw2.lol", "scheme": "https", "url_without_scheme":
       "xvw2.lol"}}],
    "has_additional_feeds": true, "additional_feeds":
     [{"title": "xvw.lol/1.xml", "lang": "eng", "url":
       {"url": "https://xvw.lol/1.xml", "scheme": "https", "url_without_scheme":
        "xvw.lol/1.xml"}},
     {"title": "xvw.lol/2.xml", "lang": "eng", "url":
      {"url": "https://xvw.lol/2.xml", "scheme": "https", "url_without_scheme":
       "xvw.lol/2.xml"}}],
    "has_location": true, "location": "France, Nantes"}
    |}]

let%expect_test "validate a full member with error" =
  let member =
    let open Data in
    record
      [
        ("id", string "x w v");
        ("bio", string "I an OCaml programmer from Belgium, living in France");
        ("has_avatar", bool true);
        ("location", bool true);
        ("nouns", list_of string [ "he"; "him"; "his"; "himself" ]);
        ("main_link", record [ ("url", string "https://xvw.lol") ]);
        ("main_feed", record [ ("url", string "https://xvw.lol/atom.xml") ]);
        ( "additional_links",
          list
            [
              record [ ("url", string "https://xvw1.lol") ];
              record [ ("ur", string "https://xvw2.lol") ];
            ] );
        ( "additional_feeds",
          list
            [
              record [ ("ur", string "https://xvw.lol/1.xml") ];
              record [ ("url", string "https://xvw.lol/2.xml") ];
            ] );
      ]
  in
  print_validated_value Member.pp (Member.validate member);
  [%expect
    {|
    <error-invalid-record field: id, <error-with-message: x w v is not a valid slug> for x w v for "x w v"
    field: location, <error-invalid-shape: strict-string> for true for true
    field: additional_links, <error-invalid-list : 01. <error-invalid-record missing field: url> for
    {"ur": "https://xvw2.lol"}> for {"url": "https://xvw1.lol"}
    {"ur": "https://xvw2.lol"} for [{"url": "https://xvw1.lol"},
                                   {"ur": "https://xvw2.lol"}]
    field: additional_feeds, <error-invalid-list : 00. <error-invalid-record missing field: url> for
    {"ur": "https://xvw.lol/1.xml"}> for {"ur": "https://xvw.lol/1.xml"}
    {"url": "https://xvw.lol/2.xml"} for [{"ur": "https://xvw.lol/1.xml"},
                                         {"url": "https://xvw.lol/2.xml"}]> for
    {"id": "x w v", "bio":
     "I an OCaml programmer from Belgium, living in France", "has_avatar": true,
    "location": true, "nouns": ["he", "him", "his", "himself"], "main_link":
     {"url": "https://xvw.lol"}, "main_feed":
     {"url": "https://xvw.lol/atom.xml"}, "additional_links":
     [{"url": "https://xvw1.lol"}, {"ur": "https://xvw2.lol"}],
    "additional_feeds":
     [{"ur": "https://xvw.lol/1.xml"}, {"url": "https://xvw.lol/2.xml"}]}
    |}]
