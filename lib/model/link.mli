(** A link is a triplet of {!type:Gem.Model.Lang.t}, {!type:Gem.Model.Url.t} and
    title.

    Once normalized, a link is a record:
    - [title] the title of the link
    - [lang] the lang of the link (normalized as a {!module:Gem.Model.Lang})
    - [url] the url of the link (normalized as a {!module:Gem.Model.Url}) *)

type t
(** The type describing a member. *)

val normalize_underlying_link : t -> (string * Yocaml.Data.t) list

val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value
(** [validate data] validate a link from a {!type:Yocaml.Data.t} value. *)

val normalize : t -> Yocaml.Data.t
(** [normalize url] serialize an link into a {!type:Yocaml.Data.t}. *)

val normalize_to_semantic_list : t list -> Yocaml.Data.t
(** Add a separator in each elements. *)

val pp : Format.formatter -> t -> unit
(** Pretty-printer for url. *)

val to_string : t -> string
(** serialize an url into a string. *)

val equal : t -> t -> bool
(** Equality between url. *)

val title : t -> string
val lang : t -> Lang.t
val url : t -> Url.t
