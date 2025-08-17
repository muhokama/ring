(** Describe a zipper element of the chain. *)

type t

val init :
  current:Member.t ->
  predecessor:Member.t ->
  successor:Member.t ->
  (unit, t) Yocaml.Task.t

val normalize : t -> (string * Yocaml.Data.t) list
