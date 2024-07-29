(** Describes the different data models used to describe the webring. Each model
    is described in a sub-module to avoid having to leake an overly large (and
    potentially useless) API. *)

(** {1 Components}

    Intermediate data models used to describe model components. *)

module Lang : sig
  (** Very minimalist support for possible languages. This model is intended to
      evolve according to the participants in the Webring. Currently, only a
      very small subset of languages is supported.

      The languages are an approximation of the
      {{:https://iso639-3.sil.org/code_tables/639/data} ISO639-3} standard
      (without linguistic precision).

      Once normalized, a language is just a string. *)

  (** Currently, a very small subset is supported but feel free to add more
      language.*)
  type t = Eng | Fra

  val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value
  (** [validate data] validate a lang from a {!type:Yocaml.Data.t} value. *)

  val normalize : t -> Yocaml.Data.t
  (** [normalize lang] serialize a lang into a {!type:Yocaml.Data.t}. *)

  val pp : Format.formatter -> t -> unit
  (** Pretty-printer for lang. *)

  val to_string : t -> string
  (** serialize a lang into a string. *)

  val equal : t -> t -> bool
  (** Equality between langs. *)
end

module Url : sig
  (** A rather naive implementation of a validator for URLs (which simply checks
      the existence of a scheme). In the near future, we will probably have to
      relay on the {{:https://ocaml.org/p/uri/latest} URI} library. Currently,
      prefix supported are:
      - http
      - https
      - gemini (because of heyPlzLookAtMe)

      Once normalized, an url has this complicated shape (to give control on the
      template side):
      - [url]: the full url representation ([scheme + "://" + url])
      - [scheme] the scheme of the url ([Http | Https | Gemini])
      - [url_without_scheme] the url without the scheme. *)

  type t
  (** The type describing an url. *)

  val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value
  (** [validate data] validate an url from a {!type:Yocaml.Data.t} value. *)

  val normalize : t -> Yocaml.Data.t
  (** [normalize url] serialize an url into a {!type:Yocaml.Data.t}. *)

  val pp : Format.formatter -> t -> unit
  (** Pretty-printer for url. *)

  val to_string : t -> string
  (** serialize an url into a string. *)

  val equal : t -> t -> bool
  (** Equality between url. *)
end

module Link : sig
  (** A link is a triplet of {!type:Gem.Model.Lang.t}, {!type:Gem.Model.Url.t}
      and title.

      Once normalized, a link is a record:
      - [title] the title of the link
      - [lang] the lang of the link (normalized as a {!module:Gem.Model.Lang})
      - [url] the url of the link (normalized as a {!module:Gem.Model.Url}) *)

  type t
  (** The type describing a member. *)

  val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value
  (** [validate data] validate a link from a {!type:Yocaml.Data.t} value. *)

  val normalize : t -> Yocaml.Data.t
  (** [normalize url] serialize an link into a {!type:Yocaml.Data.t}. *)

  val pp : Format.formatter -> t -> unit
  (** Pretty-printer for url. *)

  val to_string : t -> string
  (** serialize an url into a string. *)

  val equal : t -> t -> bool
  (** Equality between url. *)
end

module Member : sig
  (** Describes a member of Webring! A Webring member is an entity that can be
      treated independently.

      Once normalized, a member is a record:
      - [id] the slug identifier for the member (ie: [xvw])
      - [bio] a short optional string that identify the member (associated to
        [has_bio: bool])
      - [location] an short optional string that identify the location of the
        member (associated to [has_location])
      - [has_avatar] if [true] avatar that should be present in the avatar
        folder, otherwise [false]
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
end
