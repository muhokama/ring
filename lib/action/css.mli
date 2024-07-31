(** An action that copies all the CSS files from the source to the target. *)

val run : (module Sigs.RESOLVER) -> Yocaml.Action.t
