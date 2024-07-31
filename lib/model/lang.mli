(** Very minimalist support for possible languages. This model is intended to
    evolve according to the participants in the Webring. Currently, only a very
    small subset of languages is supported.

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
