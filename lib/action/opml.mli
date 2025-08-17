(** An action that builds the OPML file for the rss/atom feeds of ring members.
*)

val run : (module Sigs.RESOLVER) -> Model.Chain.t -> Yocaml.Action.t
