(** An action that builds the webring blog. *)

val run : (module Sigs.RESOLVER) -> Model.Chain.t -> Yocaml.Action.t
