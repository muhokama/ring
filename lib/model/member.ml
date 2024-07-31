open Model_util

type t = {
  id : string;
  display_name : string option;
  bio : string option;
  has_avatar : bool;
  nouns : string list;
  main_link : Link.t;
  main_feed : Link.t option;
  additional_links : Link.t list;
  additional_feeds : Link.t list;
  location : string option;
}

let id { id; _ } = id
let display_name { id; display_name; _ } = Option.value ~default:id display_name
let entity_name = "Member"
let neutral = Yocaml.Metadata.required entity_name
let validate_id = Yocaml.(Data.Validation.(Slug.validate & minimal_length 2))

let validate =
  let open Yocaml.Data.Validation in
  record (fun fields ->
      let+ id = required fields "id" validate_id
      and+ display_name =
        optional fields "display_name" (string & minimal_length 2)
      and+ bio = optional fields "bio" (string & minimal_length 5)
      and+ has_avatar = optional_or fields ~default:false "has_avatar" bool
      and+ main_link = required fields "main_link" Link.validate
      and+ main_feed = optional fields "main_feed" Link.validate
      and+ nouns = optional_or fields ~default:[] "nouns" (list_of token)
      and+ location = optional fields "location" string
      and+ additional_links =
        optional_or fields ~default:[] "additional_links"
          (list_of Link.validate)
      and+ additional_feeds =
        optional_or fields ~default:[] "additional_feeds"
          (list_of Link.validate)
      in
      {
        id;
        display_name;
        bio;
        has_avatar;
        main_link;
        main_feed;
        nouns;
        additional_links;
        additional_feeds;
        location;
      })

let normalize
    {
      id;
      display_name;
      bio;
      has_avatar;
      main_link;
      main_feed;
      nouns;
      additional_links;
      additional_feeds;
      location;
    } =
  let open Yocaml.Data in
  [
    ("id", string id);
    ("has_display_name", has_opt display_name);
    ("display_name", option string display_name);
    ("has_bio", has_opt bio);
    ("bio", option string bio);
    ("has_avatar", bool has_avatar);
    ("main_link", Link.normalize main_link);
    ("has_main_feed", has_opt main_feed);
    ("main_feed", option Link.normalize main_feed);
    ("has_nouns", has_list nouns);
    ("nouns", list_of string nouns);
    ("has_additional_links", has_list additional_links);
    ("additional_links", list_of Link.normalize additional_links);
    ("has_additional_feeds", has_list additional_feeds);
    ("additional_feeds", list_of Link.normalize additional_feeds);
    ("has_location", has_opt location);
    ("location", option string location);
  ]

let pp ppf member =
  Format.fprintf ppf "%a" Yocaml.Data.pp
    (member |> normalize |> Yocaml.Data.record)

let to_string = Format.asprintf "%a" pp

let equal
    {
      id;
      bio;
      display_name;
      has_avatar;
      main_link;
      main_feed;
      nouns;
      additional_links;
      additional_feeds;
      location;
    } other =
  String.equal id other.id
  && Option.equal String.equal bio other.bio
  && Option.equal String.equal display_name other.display_name
  && Bool.equal has_avatar other.has_avatar
  && Link.equal main_link other.main_link
  && Option.equal Link.equal main_feed other.main_feed
  && List.equal String.equal nouns other.nouns
  && List.equal Link.equal additional_links other.additional_links
  && List.equal Link.equal additional_feeds other.additional_feeds
  && Option.equal String.equal location other.location

let feed_to_outline ?main_link title description feed_url =
  Yocaml_syndication.Opml.subscription
    ~language:(feed_url |> Link.lang |> Lang.to_string)
    ~title ~description
    ?html_url:(main_link |> Option.map (fun x -> x |> Link.url |> Url.to_string))
    ~feed_url:(feed_url |> Link.url |> Url.to_string)
    ()

let to_outline member =
  let display_name = display_name member in
  let main_feed =
    let description = "Main feed of " ^ display_name in
    let title = member.main_link |> Link.title in
    member.main_feed
    |> Option.map
         (feed_to_outline ~main_link:member.main_link title description)
    |> Option.to_list
  in
  let additional_feeds =
    member.additional_feeds
    |> List.mapi (fun index feed ->
           let title = feed |> Link.title in
           let description =
             "Additional feed " ^ string_of_int index ^ "of " ^ display_name
           in
           feed_to_outline title description feed)
  in
  main_feed @ additional_feeds
