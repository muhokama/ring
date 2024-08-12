open Gem.Model
open Util

let from_list list =
  make_chain list
  |> Result.map
       (Chain.fold
          (fun acc ~pred ~curr ~succ ->
            Format.asprintf "%s\n%s [< %s | %s >]" acc (Member.id curr)
              (Member.id pred) (Member.id succ))
          "")

let%expect_test "Test with a regular chain" =
  let ctx = from_list [ member_1; member_2; member_3; member_4 ] in
  Util.print_validated_value Format.pp_print_string ctx;
  [%expect
    {|
    member-1 [< member-4 | member-2 >]
    member-2 [< member-1 | member-3 >]
    member-3 [< member-2 | member-4 >]
    member-4 [< member-3 | member-1 >]
    |}]

let%expect_test "Test with an empty chain" =
  let ctx = from_list [] in
  Util.print_validated_value Format.pp_print_string ctx;
  [%expect {| |}]

let%expect_test "Test with an 1-element chain" =
  let ctx = from_list [ member_1 ] in
  Util.print_validated_value Format.pp_print_string ctx;
  [%expect {| member-1 [< member-1 | member-1 >] |}]

let%expect_test "Test with an 2-element chain" =
  let ctx = from_list [ member_1; member_2 ] in
  Util.print_validated_value Format.pp_print_string ctx;
  [%expect
    {|
    member-1 [< member-2 | member-2 >]
    member-2 [< member-1 | member-1 >]
    |}]
