(** An action that builds the chain of links for each member. *)

val run : (module Sigs.RESOLVER) -> Model.Chain.t -> Yocaml.Action.t
