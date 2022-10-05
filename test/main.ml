(** Test file for Blackjack system. *)

open OUnit2
open Blackjack

let suite = "Test Suite for Blackjack System" >::: List.flatten []
let _ = run_test_tt_main suite