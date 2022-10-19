open OUnit2
open Blackjack
open Card
open Command
open Deck

let card_tests = [ raise (Failure "Unimplemented") ]
let command_tests = [ raise (Failure "Unimplemented") ]
let state_tests = [ raise (Failure "Unimplemented") ]

let suite =
  "test suite for final project"
  >::: List.flatten [ card_tests; command_tests; state_tests ]

let _ = run_test_tt_main suite
