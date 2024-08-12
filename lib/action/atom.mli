(** An action that builds the Atom file of the federated blog. *)

val run : (module Sigs.RESOLVER) -> Model.Chain.t -> Yocaml.Action.t
