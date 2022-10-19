(** Test file for Blackjack system. *)

open OUnit2
open Blackjack
open Card
open Command
open Deck

let test_card_1 = init_card Ace Diamonds [ 1; 11 ]
let test_card_2 = init_card (Number 2) Spades [ 2 ]
let test_empty = empty
let test_standard = standard
let test_add_on_empty = add empty test_card_1
let test_add_on_1card = add test_add_on_empty test_card_2

(* ########################### CARD TESTS ################################### *)

(** [string_of_card_test name c expected_output] constructs an OUnit test named
    [name] that asserts the quality of [expected_output] with
    [Card.string_of_card c]. *)
let string_of_card_test (name : string) (c : Card.t) (expected_output : string)
    : test =
  name >:: fun _ ->
  assert_equal expected_output (string_of_card c) ~printer:Fun.id

let string_of_card_tests =
  [
    string_of_card_test "Ace of Diamonds" test_card_1 "Ace of Diamonds";
    string_of_card_test "2 of Spades" test_card_2 "2 of Spades";
  ]

let card_tests = List.flatten [ string_of_card_tests ]

(* ######################## COMMAND TESTS ################################### *)

(** [string_of_command] is the string representation of [c], a [Command.command]
    value. *)
let string_of_command (c : Command.command) : string =
  match c with
  | Hit -> "Hit"
  | Stand -> "Stand"
  | Quit -> "Quit"
  | _ -> failwith "Unimplemented Commands"

(** [parse_test name str expected_output] constructs an OUnit test named [name]
    that asserts the quality of [expected_output] with [Command.parse str]. *)
let parse_test (name : string) (str : string)
    (expected_output : Command.command) : test =
  name >:: fun _ ->
  assert_equal expected_output (parse str) ~printer:string_of_command

(** [parse_fail_test name str e] constructs an OUnit test named [name] that
    asserts that exception [e] is appropriately raised by [Command.parse str].
    Invariant: [e] is either [Empty] or [Malformed]. *)
let parse_fail_test (name : string) (str : string) e : test =
  name >:: fun _ -> assert_raises e (fun () -> parse str)

let command_tests =
  [
    parse_test "Hit" "hit" Hit;
    parse_test "Stand" "    stand" Stand;
    parse_test "Quit" "    quit      " Quit;
    parse_fail_test "empty string" "" Empty;
    parse_fail_test "command with extra characters" "hit abc" Malformed;
    parse_fail_test "invalid command" "draw" Malformed;
  ]
(* ( " bet 500 is Bet 500" >:: fun _ -> assert_equal (Bet 500) (parse " bet 500
   ") ); ("hit is Hit" >:: fun _ -> assert_equal Hit (parse "hit")); *)

(* ########################### DECK TESTS ################################### *)

(** [string_of_deck_test name d expected_output] constructs an OUnit test named
    [name] that asserts the quality of [expected_output] with
    [Deck.string_of_deck d]. *)
let string_of_deck_test (name : string) (d : Deck.t) (expected_output : string)
    : test =
  name >:: fun _ ->
  assert_equal expected_output (string_of_deck d) ~printer:Fun.id

(** [construct_ranks_string] is a string representation of cards with ranks
    [ranks] and suit [suit]. The order of the individual string representations
    is dependent on the order of the ranks specified in [ranks]. *)
let rec construct_ranks_string (ranks : string list) (suit : string) : string =
  match ranks with
  | [] -> ""
  | [ h ] -> h ^ " of " ^ suit
  | h :: t -> h ^ " of " ^ suit ^ ", " ^ construct_ranks_string t suit

(** [construct_standard_string] is a string representation of cards with ranks
    [ranks] and suits [suits]. The order of the individual string representation
    is dependent on the order of the ranks specified in [ranks] and the order of
    the suits specified in [suits]. The string representation is primarily
    sorted first by suit, then by rank (i.e. the suits are clustered together,
    then the ranks are ordered correctly). *)
let rec construct_standard_string (ranks : string list) (suits : string list) :
    string =
  match suits with
  | [] -> ""
  | [ h ] -> construct_ranks_string ranks h
  | h :: t ->
      construct_ranks_string ranks h ^ ", " ^ construct_standard_string ranks t

let standard_string =
  construct_standard_string
    [
      "Ace";
      "2";
      "3";
      "4";
      "5";
      "6";
      "7";
      "8";
      "9";
      "10";
      "Jack";
      "Queen";
      "King";
    ]
    [ "Spades"; "Hearts"; "Clubs"; "Diamonds" ]

let string_of_deck_tests =
  [
    string_of_deck_test "empty val test" test_empty "";
    string_of_deck_test "standard val test" test_standard standard_string;
    string_of_deck_test "card add test empty" test_add_on_empty
      "Ace of Diamonds";
    string_of_deck_test "card add test 1card already" test_add_on_1card
      "2 of Spades, Ace of Diamonds";
  ]

(** [size_test name d expected_output] constructs an OUnit test named [name]
    that asserts the quality of [expected_output] with [Deck.size d]. *)
let size_test (name : string) (d : Deck.t) (expected_output : int) : test =
  name >:: fun _ -> assert_equal expected_output (size d) ~printer:string_of_int

let size_tests =
  [
    size_test "size of empty is 0" test_empty 0;
    size_test "size of standard is 52" test_standard 52;
    size_test "size of one card deck" test_add_on_empty 1;
    size_test "size of two card deck" test_add_on_1card 2;
  ]

let deck_tests = List.flatten [ string_of_deck_tests; size_tests ]

(* ########################## TEST SUITE #################################### *)

let suite =
  "test suite for final project"
  >::: List.flatten [ card_tests; command_tests; deck_tests ]

let _ = run_test_tt_main suite
