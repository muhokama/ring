(** The global process that executes all actions sequentially. *)

val run : (module Sigs.RESOLVER) -> unit -> unit Yocaml.Eff.t
