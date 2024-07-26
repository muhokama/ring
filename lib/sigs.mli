(** Describes a resolver in terms of a source and a target. *)

(** {1 Resolver}

    Description of the requirements needed to describe a {!module:Gem.Resolver}. *)

module type RESOLVABLE = sig
  (** A resolvable module is used to describe a resolver for calculating source,
      target and URL paths in the generated application. *)

  val source : Yocaml.Path.t
  (** Describes the source of static data and components. *)

  val target : Yocaml.Path.t
  (** Describes the destination target of the application. *)
end

module type RESOLVER = sig
  (** Describes the resolver. *)

  include RESOLVABLE
  (** @inline *)

  (** {1 Source}

      Provides utilities for building paths relative to the project source. *)

  module Source : sig
    (** Describes the source resolvers. *)

    val root : Yocaml.Path.t
    (** [R.Source.root] is [R.source]. *)

    val data : Yocaml.Path.t
    (** Resolve the [data-path] ([source / data]). *)

    val static : Yocaml.Path.t
    (** Resolve the [static-path] ([source / static]). *)

    val css : Yocaml.Path.t
    (** Resolve the [css-path] ([source / static / css]). *)

    val templates : Yocaml.Path.t
    (** Resolve the [templates-path] ([source / static / templates]). *)

    val template : Yocaml.Path.fragment -> Yocaml.Path.t
    (** [template ?ext file] resolve a template file located into [templates]
        directory.

        {b Warning} The function simply produces a path, there is no guarantee
        that the template exists. *)
  end

  (** {1 Target}

      Provides utilities for building paths relative to the project target. *)

  module Target : sig
    (** Describes the target resolvers. *)

    val root : Yocaml.Path.t
    (** [R.Target.root] is [R.target]. *)
  end
end
