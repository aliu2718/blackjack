open Blackjack.Deck
open Blackjack.State

(** [new_round_prompt st] provides information for starting a new round, i.e.
    dealing new cards to a fresh hand to the player and dealer, and informing
    the player of their hand, the dealer's hand, and the values. *)
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
    ^ ")\n")

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
  new_round_prompt session

(* Execute the game engine. *)
let () = main ()