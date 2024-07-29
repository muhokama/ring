(** Describes the Chain of participants. A chain is a list of participants where
    each participant has a successor and a predecessor. *)

(** {1 Types}

    Describes the list of participants and the chain of participants. *)

type t

(** {1 Interaction with the chain} *)

val init : chain:string list -> members:Model.Member.t list -> t
(** Intialize thes chain of the application, used for generating every pages.
    The chain is a list of member (that maintain the order) and members is just
    the list of members, if a member from the chain is not present in the
    [members] set, the member is discared from the chain. Members not present in
    the chain are discarded (also). *)

val fold :
  ('a ->
  pred:Model.Member.t ->
  curr:Model.Member.t ->
  succ:Model.Member.t ->
  'a) ->
  'a ->
  t ->
  'a
(** [fold f default chain] Traverses all the elements in the chain by applying a
    function that takes the predecessor, the current member, the successor and
    the current state. *)
