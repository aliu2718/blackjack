(** Test file for Blackjack system. *)

open OUnit2
open Blackjack
open Card
open Command
open Deck
open State

let test_card_1 = init_card Ace Diamonds [ 1; 11 ]
let test_card_2 = init_card (Number 2) Spades [ 2 ]
let test_card_3 = init_card (Number 3) Clubs [ 3 ]
let test_ace_of_spades = init_card Ace Spades [ 1; 11 ]
let test_add_on_empty = add empty test_card_1
let test_add_on_1card = add test_add_on_empty test_card_2
let test_another_1card_deck = add empty test_card_3
let test_combine_empty = combine empty test_another_1card_deck
let test_combine_nonempty = combine test_another_1card_deck test_add_on_1card

(* ########################### CARD TESTS ################################### *)

(** [string_of_int_list lst] is the string representation of list [lst]. *)
let rec string_of_int_list lst =
  "[" ^ String.concat "; " (List.map string_of_int lst) ^ "]"

(** [values_test name c expected_output] constructs an OUnit test named [name]
    that asserts the quality of [expected_output] with [Card.values c]. *)
let values_test (name : string) (c : Card.t) (expected_output : int list) : test
    =
  name >:: fun _ ->
  assert_equal expected_output (values c) ~printer:string_of_int_list

let values_tests =
  [
    values_test "2 of Spades" test_card_2 [ 2 ];
    values_test "Ace of Diamonds" test_card_1 [ 1; 11 ];
  ]

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

let card_tests = List.flatten [ values_tests; string_of_card_tests ]

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
    string_of_deck_test "empty val test" empty "";
    string_of_deck_test "standard val test" standard standard_string;
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
    size_test "size of empty is 0" empty 0;
    size_test "size of standard is 52" standard 52;
    size_test "size of one card deck" test_add_on_empty 1;
    size_test "size of two card deck" test_add_on_1card 2;
  ]

(** [combine_test] constructs an OUnit test named [name] that asserts the
    quality of [expected_output] with [Deck.combine d1 d2]. *)
let combine_test (name : string) (d1 : Deck.t) (d2 : Deck.t)
    (expected_output : string) : test =
  name >:: fun _ ->
  assert_equal expected_output (string_of_deck (combine d1 d2)) ~printer:Fun.id

let combine_tests =
  [
    combine_test "combine two empty decks" empty empty "";
    combine_test "put nonempty deck on empty deck" empty standard
      standard_string;
    combine_test "put empty deck on nonempty deck" standard empty
      standard_string;
    combine_test "combine nonempty decks" standard standard
      (standard_string ^ ", " ^ standard_string);
  ]

(** [peek_test name d expected_output] constructs an OUnit test named [name]
    that asserts the quality of [expected_output] with [Deck.peek d]. *)
let peek_test (name : string) (d : Deck.t) (expected_output : Card.t) : test =
  name >:: fun _ ->
  assert_equal expected_output (peek d) ~printer:string_of_card

(** [peek_fail_test name d] constructs an OUnit test named [name] that asserts
    that exception [EmptyDeck] is raised by [Deck.peek d]. *)
let peek_fail_test (name : string) (d : Deck.t) : test =
  name >:: fun _ -> assert_raises EmptyDeck (fun () -> peek d)

let peek_tests =
  [
    peek_test "standard deck" standard test_ace_of_spades;
    peek_test "peeking 2 of spades" test_add_on_1card test_card_2;
    peek_fail_test "peeking empty deck" empty;
  ]

(** [add_test name d c expected_output] constructs an OUnit test named [name]
    that asserts the quality of [expected_output] with [Deck.add d c]. *)
let add_test (name : string) (d : Deck.t) (c : Card.t)
    (expected_output : Card.t) : test =
  name >:: fun _ ->
  assert_equal expected_output (peek (add d c)) ~printer:string_of_card

let add_tests =
  [
    add_test "add to empty deck" empty test_ace_of_spades test_ace_of_spades;
    add_test "add to standard deck" standard test_card_1 test_card_1;
    add_test "add to one card deck" test_add_on_empty test_card_2 test_card_2;
  ]

(** [draw_test name d expected_output] constructs an OUnit test named [name]
    that asserts the quality of [expected_output] with [Deck.draw d]. *)
let draw_test (name : string) (d : Deck.t) (expected_output : Card.t * Deck.t) :
    test =
  name >:: fun _ -> assert_equal expected_output (draw d)

(** [draw_test name d expected_output] constructs an OUnit test named [name]
    that asserts the quality of the equation specification of [Deck.draw d],
    namely:

    - If Deck.draw d = (c, d'), then Deck.add d' c = d. *)
let draw_eq_test (name : string) (d : Deck.t) : test =
  name >:: fun _ ->
  assert_equal d
    (let c, d' = draw d in
     add d' c)
    ~printer:string_of_deck

(** [draw_fail_test name d] constructs an OUnit test named [name] that asserts
    that exception [EmptyDeck] is raised by [Deck.draw d]. *)
let draw_fail_test (name : string) (d : Deck.t) : test =
  name >:: fun _ -> assert_raises EmptyDeck (fun () -> draw d)

let draw_tests =
  [
    draw_test "draw from one card deck" test_add_on_empty (test_card_1, empty);
    draw_test "draw from two card deck" test_add_on_1card
      (test_card_2, test_add_on_empty);
    draw_eq_test "standard deck equation specification" standard;
    draw_eq_test "1-card deck equation specification" test_another_1card_deck;
    draw_fail_test "drawing from empty deck" empty;
  ]

(** [shuffled_decks_generator] is a list of [n] randomly shuffled copies of deck
    [d]. Invariant: [n] > 0. *)
let shuffled_decks_generator n d =
  Array.make n d |> Array.to_list |> List.map shuffle

(** [shuffle_test name d n expected_output] constructs an OUnit test named
    [name] that asserts whether [d] is expected to appear in [n] randomly
    shuffled copies of [d]. This test leverages the fact that for a sufficiently
    large deck and for a sufficiently small [n], the probability of
    [Deck.shuffle d] being identical to [d] is extraordinarily unlikely:

    - For a standard 52-card deck, the probability of a shuffled copy of [d]
      having the same card ordering as [d] is on the order of O(n * 10 ^ -68).

    However, for deck sizes of 0 or 1, [Deck.shuffle d] is equal to [d].
    Invariant: [n] > 0. *)
let shuffle_test (name : string) (d : Deck.t) (n : int) (expected_output : bool)
    : test =
  let shuffled_decks = shuffled_decks_generator n d in
  name >:: fun _ ->
  assert_equal expected_output
    (List.mem d shuffled_decks)
    ~printer:string_of_bool

let shuffle_tests =
  [
    shuffle_test "empty deck" empty 1 true;
    shuffle_test "1-card deck" test_add_on_empty 1 true;
    shuffle_test "1 randomly shuffled standard deck" standard 1 false;
    shuffle_test "100 randomly shuffled standard decks" standard 100 false;
    shuffle_test "1000 randomly shuffled standard decks" standard 1000 false;
  ]

let deck_tests =
  List.flatten
    [
      string_of_deck_tests;
      size_tests;
      combine_tests;
      peek_tests;
      add_tests;
      draw_tests;
      shuffle_tests;
    ]

(* ########################## STATE TESTS ################################### *)

(** [current_hand_test name st expected_output] constructs an OUnit test named
    [name] that asserts the quality of [expected_output] with
    [State.hand_size (State.current_hand st)]. Since the cards in a hand are
    random, [State.current_hand st] is tested against the expected hand length. *)
let current_hand_test (name : string) (st : State.t) (expected_output : int) :
    test =
  name >:: fun _ ->
  assert_equal expected_output
    (hand_size (current_hand st))
    ~printer:string_of_int

let current_hand_tests =
  [ current_hand_test "initial primitive state" init_state 0 ]

(** [dealer_hand_test name st expected_output] constructs an OUnit test named
    [name] that asserts the quality of [expected_output] with
    [State.hand_size (State.dealer_hand st)]. Since the cards in a hand are
    random, [State.dealer_hand st] is tested against the expected hand length. *)
let dealer_hand_test (name : string) (st : State.t) (expected_output : int) :
    test =
  name >:: fun _ ->
  assert_equal expected_output
    (hand_size (dealer_hand st))
    ~printer:string_of_int

let dealer_hand_tests =
  [ dealer_hand_test "initial primitive state" init_state 0 ]

let state_tests = List.flatten [ current_hand_tests; dealer_hand_tests ]

(* ########################## TEST SUITE #################################### *)

let suite =
  "test suite for final project"
  >::: List.flatten [ card_tests; command_tests; deck_tests; state_tests ]

let _ = run_test_tt_main suite
