(** An action that copies the CNAME of the existing webring. *)

val run : (module Sigs.RESOLVER) -> Yocaml.Action.t
