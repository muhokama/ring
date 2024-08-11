(** Describes an external Article. *)

type t
(** The type describing an article. *)

val authors_in_chain : Chain.t -> t -> bool
(** Ensure that authors are present in chain. *)

val pp : Format.formatter -> t -> unit

(** {1 Dealing as metadata} *)

include Yocaml.Required.DATA_READABLE with type t := t
include Yocaml.Required.DATA_INJECTABLE with type t := t
