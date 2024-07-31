(** An action that initiates the copying of files from a source directory to a
    target directory. *)

val run :
  ?extension:string list ->
  source:Yocaml.Path.t ->
  target:Yocaml.Path.t ->
  Yocaml.Action.t
