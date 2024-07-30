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

  val track_common_dependencies : (unit, unit) Yocaml.Task.t
  (** An arrow that track common dependencies*)

  (** {1 Source}

      Provides utilities for building paths relative to the project source. *)

  module Source : sig
    (** Describes the source resolvers. *)

    val root : Yocaml.Path.t
    val binary : Yocaml.Path.t
    val cname : Yocaml.Path.t
    val common_deps : Yocaml.Path.t list
    val data : Yocaml.Path.t
    val static : Yocaml.Path.t
    val css : Yocaml.Path.t
    val fonts : Yocaml.Path.t
    val templates : Yocaml.Path.t
    val members : Yocaml.Path.t
    val chain : Yocaml.Path.t
    val index : Yocaml.Path.t

    val template : Yocaml.Path.fragment -> Yocaml.Path.t
    (** [template ?ext file] resolve a template file located into [templates]
        directory.

        {b Warning} The function simply produces a path, there is no guarantee
        that the template exists. *)

    val static_images : Yocaml.Path.t
  end

  (** {1 Target}

      Provides utilities for building paths relative to the project target. *)

  module Target : sig
    (** Describes the target resolvers. *)

    val root : Yocaml.Path.t
    val cache : Yocaml.Path.t
    val css : Yocaml.Path.t
    val fonts : Yocaml.Path.t
    val opml : Yocaml.Path.t
    val ring_opml : Yocaml.Path.t
    val index : Yocaml.Path.t
    val images : Yocaml.Path.t
    val members : Yocaml.Path.t
    val member_redirection : id:string -> [ `Pred | `Succ ] -> Yocaml.Path.t
  end
end
