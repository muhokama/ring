(** An action that builds the webring index. *)

val run : (module Sigs.RESOLVER) -> Model.Chain.t -> Yocaml.Action.t
