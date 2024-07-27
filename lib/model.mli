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

      Once standardised, a language is just a string. *)

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

      Once standardised, an url has this complicated shape (to give control on
      the template side):
      - [url]: the full url representation ([scheme + "://" + url])
      - [scheme] the scheme of the url ([Http | Https | Gemini])
      - [url_without_scheme] the url without the scheme. *)

  type t

  val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value
  (** [validate data] validate an url from a {!type:Yocaml.Data.t} value. *)

  val normalize : t -> Yocaml.Data.t
  (** [normalize url] serialize am url into a {!type:Yocaml.Data.t}. *)

  val pp : Format.formatter -> t -> unit
  (** Pretty-printer for url. *)

  val to_string : t -> string
  (** serialize an url into a string. *)

  val equal : t -> t -> bool
  (** Equality between url. *)
end
