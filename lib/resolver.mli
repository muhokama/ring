(** Resolvers are used to resolve the various paths (to reach the source, the
    target and to generate URLs within the application).

    A resolver is parameterised by a [source] path, which describes where to
    find the various components needed to build artefacts, and a [target] path,
    which allows the generation artefacts to be described {i or built}. *)

module Make (_ : Sigs.RESOLVABLE) : Sigs.RESOLVER
