(** Describes the Chain of participants. A chain is a list of participants where
    each participant has a successor and a predecessor. *)

(** {1 Types}

    Describes the list of participants and the chain of participants. *)

type t

val empty : t
(** Returns an empty chain. *)

(** {1 Interaction with the chain} *)

val init : chain:string list -> members:Member.t list -> t
(** Intialize thes chain of the application, used for generating every pages.
    The chain is a list of member (that maintain the order) and members is just
    the list of members, if a member from the chain is not present in the
    [members] set, the member is discared from the chain. Members not present in
    the chain are discarded (also). *)

val fold :
  ('a -> pred:Member.t -> curr:Member.t -> succ:Member.t -> 'a) -> 'a -> t -> 'a
(** [fold f default chain] Traverses all the elements in the chain by applying a
    function that takes the predecessor, the current member, the successor and
    the current state. *)

val to_list : t -> (Member.t * (Member.t * Member.t)) list
(** [to_list chain] returns a chain into a list of [curr, (pred, succ)]. *)

val to_opml : (t, string) Yocaml.Task.t
(** [to_opml] An arrow that lift a chain into an OPML file. *)

val as_author : t -> string -> Yocaml_syndication.Person.t
val to_authors : t -> Yocaml_syndication.Person.t Yocaml.Nel.t
val is_empty : t -> bool
val normalize : t -> Yocaml.Data.t

(** {1 Reading chain from a file} *)

module Metadata : sig
  type t = string list

  include Yocaml.Required.DATA_READABLE with type t := t
end
