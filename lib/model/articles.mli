(** Describes a federation page of external articles published by ring members.
*)

type t
(** The type describing the federation. *)

val index : ?limit:int -> Chain.t -> Yocaml.Path.t -> (Page.t, t) Yocaml.Task.t
val atom : Chain.t -> Yocaml.Path.t -> (unit, string) Yocaml.Task.t

(** {1 Dealing as metadata} *)

include Yocaml.Required.DATA_INJECTABLE with type t := t
