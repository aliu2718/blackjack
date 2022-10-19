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

let string_of_deck_test (name : string) (d : Deck.t) (expected_output : string)
    : test =
  name >:: fun _ ->
  assert_equal expected_output (string_of_deck d) ~printer:Fun.id

let size_test (name : string) (d : Deck.t) (expected_output : int) : test =
  name >:: fun _ -> assert_equal expected_output (size d) ~printer:string_of_int

let test_card_1 = init_card Ace Diamonds [ 1; 11 ]
let test_empty = empty
let test_standard = standard

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

let deck_tests =
  [
    string_of_deck_test "empty val test" test_empty "";
    string_of_deck_test "standard val test" test_standard
      "(Ace, Spades, [1; 11]) (Number 2, Spades, [2]) (Number 3, Spades, [3]) \
       (Number 4, Spades, [4]) (Number 5, Spades, [5]) (Number 6, Spades, [6]) \
       (Number 7, Spades, [7]) (Number 8, Spades, [8]) (Number 9, Spades, [9]) \
       (Number 10, Spades, [10]) (Jack, Spades, [10]) (Queen, Spades, [10]) \
       (King, Spades, [10]) (Ace, Hearts, [1; 11]) (Number 2, Hearts, [2]) \
       (Number 3, Hearts, [3]) (Number 4, Hearts, [4]) (Number 5, Hearts, [5]) \
       (Number 6, Hearts, [6]) (Number 7, Hearts, [7]) (Number 8, Hearts, [8]) \
       (Number 9, Hearts, [9]) (Number 10, Hearts, [10]) (Jack, Hearts, [10]) \
       (Queen, Hearts, [10]) (King, Hearts, [10]) (Ace, Clubs, [1; 11]) \
       (Number 2, Clubs, [2]) (Number 3, Clubs, [3]) (Number 4, Clubs, [4]) \
       (Number 5, Clubs, [5]) (Number 6, Clubs, [6]) (Number 7, Clubs, [7]) \
       (Number 8, Clubs, [8]) (Number 9, Clubs, [9]) (Number 10, Clubs, [10]) \
       (Jack, Clubs, [10]) (Queen, Clubs, [10]) (King, Clubs, [10]) (Ace, \
       Diamonds, [1; 11]) (Number 2, Diamonds, [2]) (Number 3, Diamonds, [3]) \
       (Number 4, Diamonds, [4]) (Number 5, Diamonds, [5]) (Number 6, \
       Diamonds, [6]) (Number 7, Diamonds, [7]) (Number 8, Diamonds, [8]) \
       (Number 9, Diamonds, [9]) (Number 10, Diamonds, [10]) (Jack, Diamonds, \
       [10]) (Queen, Diamonds, [10]) (King, Diamonds, [10])";
    size_test "size of empty is 0" test_empty 0;
    size_test "size of standard is 52" test_standard 52;
  ]

let suite =
  "test suite for final project"
  >::: List.flatten [ card_tests; command_tests; deck_tests ]

let _ = run_test_tt_main suite
