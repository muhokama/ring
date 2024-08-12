(** Some tools (such as pretty-printers) are useful for testing. *)

val print_validated_value :
  (Format.formatter -> 'a -> unit) ->
  'a Yocaml.Data.Validation.validated_value ->
  unit
(** Print a validated value (for expect-test). Mostly a readable value (but
    not-so exhaustive) *)

val make_member : string -> string -> string * Yocaml.Data.t

val make_chain :
  (string * Yocaml.Data.t) list ->
  Gem.Model.Chain.t Yocaml.Data.Validation.validated_value

val member_1 : string * Yocaml.Data.t
val member_2 : string * Yocaml.Data.t
val member_3 : string * Yocaml.Data.t
val member_4 : string * Yocaml.Data.t
