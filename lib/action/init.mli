(** An action (not in the Yocaml sense) which initializes the cache and builds
    the chain. *)

val run :
  (module Sigs.RESOLVER) -> (Yocaml.Cache.t * Model.Chain.t) Yocaml.Eff.t
