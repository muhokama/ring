(** All the actions used to build the ring. *)

val process_all : (module Sigs.RESOLVER) -> unit -> unit Yocaml.Eff.t
(** Process all action in order to produce [ring.muhokama]. *)
