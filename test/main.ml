(** Test file for Blackjack system. *)

open OUnit2
open Blackjack
open Card
open Command
open Deck

(** [string_of_card_test name c expected_output] constructs an OUnit test named
    [name] that asserts the quality of [expected_output] with
    [string_of_card c]. *)
let string_of_card_test (name : string) (c : Card.t) (expected_output : string)
    : test =
  name >:: fun _ ->
  assert_equal expected_output (string_of_card c) ~printer:Fun.id

let empty_test (name : string) (expected_output : Deck.t) : test =
  name >:: fun _ -> assert_equal expected_output empty ~printer:string_of_deck

let test_card_1 = init_card Ace Diamonds [ 1; 11 ]
let test_empty = empty

let card_tests =
  [
    (* string_of_card_test *)
    string_of_card_test "String of test_card_1" test_card_1
      "(Ace, Diamonds, [1; 11])";
  ]

let command_tests =
  [
    "parse test suite"
    >::: [
           ( "    bet   500    is Bet 500" >:: fun _ ->
             assert_equal (Bet 500) (parse "    bet   500   ") );
           ("hit is Hit" >:: fun _ -> assert_equal Hit (parse "hit"));
         ];
  ]

let deck_tests = [ empty_test "Empty constructor test" test_empty ]

let suite =
  "test suite for final project"
  >::: List.flatten [ card_tests; command_tests; deck_tests ]

let _ = run_test_tt_main suite
