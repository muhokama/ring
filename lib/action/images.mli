(** An action that copies all the images files from the source to the target. *)

val run : (module Sigs.RESOLVER) -> Yocaml.Action.t
