open Blackjack.Command
open Blackjack.Deck
open Blackjack.State

(** [quit_prompt ()] prints a farewell message, then terminates the Blackjack
    game without error messages and exceptions. *)
let quit_prompt () =
  ANSITerminal.print_string [ ANSITerminal.green ]
    "\n\
     You have successfully quit the Blackjack game. Thank you for playing! \
     Exiting the session...\n";
  Stdlib.exit 0

(** [new_round_prompt st] is the new state resulting from starting a new round.
    It also handles start the round and provides information about the new
    round, i.e. dealing new cards to a fresh hand to the player and dealer, and
    informing the player of their hand, the dealer's hand, and the values. *)
let new_round_prompt st =
  ANSITerminal.print_string [ ANSITerminal.yellow ]
    "\nDealing new cards for the round...\n\n";
  let st' = start_round st in
  let p_hand = current_hand st' in
  let d_hand = dealer_hand st' in
  ANSITerminal.print_string [ ANSITerminal.yellow ] "The Dealer's hand is: ";
  print_string
    (string_of_hand d_hand ^ "  (Current Value: "
    ^ string_of_value (val_hand d_hand)
    ^ ")\n");
  ANSITerminal.print_string [ ANSITerminal.yellow ] "Your hand is: ";
  print_string
    (string_of_hand p_hand ^ "  (Current Value: "
    ^ string_of_value (val_hand p_hand)
    ^ ")\n");
  st'

let rec main_prompt st =
  print_endline "\nWhat would you like to do?";
  print_string "> ";
  match read_line () with
  | input -> begin
      match parse input with
      | exception Empty ->
          ANSITerminal.print_string [ ANSITerminal.red ]
            "\nYou have not entered an action. Please try again.\n\n";
          main_prompt st
      | exception Malformed ->
          ANSITerminal.print_string [ ANSITerminal.red ]
            "\nYou have entered an invalid action. Please try again.\n\n";
          main_prompt st
      | Quit -> quit_prompt ()
      | _ -> raise (Failure "Filler")
    end

(** [main ()] starts a session of the Blackjack game. *)
let main () =
  ANSITerminal.print_string [ ANSITerminal.yellow ]
    "\n\nWelcome to the Text-based Single-player Blackjack Game.\n\n";
  ANSITerminal.print_string [ ANSITerminal.green ]
    "Initializing new Blackjack session...\n";
  let session = load_state in
  let num_decks = deck_size session / 52 in
  ANSITerminal.print_string [ ANSITerminal.green ]
    ("Successfully loaded new Blackjack game with " ^ string_of_int num_decks
   ^ " 52-card standard decks...\n\n\n");
  let session' = new_round_prompt session in
  main_prompt session'

(* Execute the game engine. *)
let () = main ()