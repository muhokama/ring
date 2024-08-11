(** Describes a member of Webring! A Webring member is an entity that can be
    treated independently.

    Once normalized, a member is a record:
    - [id] the slug identifier for the member (ie: [xvw])
    - [bio] a short optional string that identify the member (associated to
      [has_bio: bool])
    - [location] an short optional string that identify the location of the
      member (associated to [has_location])
    - [has_avatar] if [true] avatar that should be present in the avatar folder,
      otherwise [false]
    - [main_link] the main link of the the member
    - [main_feed] an optional link that point the main RSS/ATOM feed of the
      member (associated to [has_main_feed])
    - [nouns] an optional list of string that describes nouns of the member
      (associated to [has_nouns])
    - [additional_links] an optional list of additional links (associated to
      [has_additional_links])
    - [additional_feeds] an optional list of additional feeds (associated to
      [has_additional_feeds]) *)

type t
(** The type describing a member. *)

val pp : Format.formatter -> t -> unit
(** Pretty-printer for members. *)

val to_string : t -> string
(** serialize a member into a string. *)

val equal : t -> t -> bool
(** Equality between members. *)

(** {1 Dealing as metadata} *)

include Yocaml.Required.DATA_READABLE with type t := t
include Yocaml.Required.DATA_INJECTABLE with type t := t

(** {1 Accessors and Mutators} *)

val id : t -> string
(** Returns the id of a member. *)

val display_name : t -> string

(** {1 OPML generation} *)

val to_outline : t -> Yocaml_syndication.Opml.outline list
(** [to_outline m] transform a member to a list of OPML outlines. *)
