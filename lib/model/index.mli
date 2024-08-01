(** Describes an index provided by a page, centres of interest and the chain of
    members. *)

type t
(** The type describing the index page. *)

val merge_chain : Chain.t -> (t, t) Yocaml.Task.t

(** {1 Dealing as metadata} *)

include Yocaml.Required.DATA_READABLE with type t := t
include Yocaml.Required.DATA_INJECTABLE with type t := t
