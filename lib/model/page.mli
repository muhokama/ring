(** Describes a generic page, mostly used on top of another model. *)

type t
(** The type describing a page. *)

val empty : t

val validate_underlying_page :
  (string * Yocaml.Data.t) list -> t Yocaml.Data.Validation.validated_record

(** {1 Dealing as metadata} *)

include Yocaml.Required.DATA_READABLE with type t := t
include Yocaml.Required.DATA_INJECTABLE with type t := t
