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

type scheme = Http | Https | Gemini

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

val scheme : t -> scheme
val url : t -> string
