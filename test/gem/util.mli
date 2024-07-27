(** Some tools (such as pretty-printers) are useful for testing. *)

val print_validated_value :
  (Format.formatter -> 'a -> unit) ->
  'a Yocaml.Data.Validation.validated_value ->
  unit
(** Print a validated value (for expect-test). Mostly a readable value (but
    not-so exhaustive) *)
