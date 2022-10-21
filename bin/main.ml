open Blackjack.Card
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

(** [print_hands st] prints a prompt containing information of the cards in the
    dealer's hand and player's hand. *)
let print_hands st =
  let p_hand = current_hand st in
  let d_hand = dealer_hand st in
  ANSITerminal.print_string [ ANSITerminal.yellow ] "The Dealer's hand is: ";
  print_endline
    (string_of_hand d_hand ^ "  (Current Value: "
    ^ string_of_value (val_hand d_hand)
    ^ ")");
  ANSITerminal.print_string [ ANSITerminal.yellow ] "Your hand is: ";
  print_endline
    (string_of_hand p_hand ^ "  (Current Value: "
    ^ string_of_value (val_hand p_hand)
    ^ ")")

(** [busted_prompt ()] prints a prompt for when the player busts their hand. *)
let busted_prompt () =
  ANSITerminal.print_string [ ANSITerminal.red ] "\n\nYour hand was a bust!\n";
  ANSITerminal.print_string [ ANSITerminal.yellow ]
    "Starting a new round...\n\n"

(** [blackjack_prompt ()] prints a prompt for when the player hits a Blackjack. *)
let blackjack_prompt () =
  ANSITerminal.print_string [ ANSITerminal.green ]
    "\n\nYou have hit a Blackjack!\n";
  ANSITerminal.print_string [ ANSITerminal.yellow ]
    "Starting a new round...\n\n"

(** [new_round_prompt st] is the new state resulting from starting a new round.
    It also handles start the round and provides information about the new
    round, i.e. dealing new cards to a fresh hand to the player and dealer, and
    informing the player of their hand, the dealer's hand, and the values. *)
let rec new_round_prompt st =
  ANSITerminal.print_string [ ANSITerminal.magenta ]
    "\nDealing new cards for the round...\n\n";
  let st' = start_round st in
  print_hands st';
  if check_status st' = BlackjackWin then
    let () = blackjack_prompt () in
    new_round_prompt st'
  else st'

(** [hit_prompt st] is the new state resulting from the player playing the "hit"
    action. It also handles printing relevant information for the action. *)
let hit_prompt st =
  ANSITerminal.print_string [ ANSITerminal.magenta ]
    "\n\nHitting the deck...\n\n";
  let c, st' = hit st in
  ANSITerminal.print_string [ ANSITerminal.yellow ] "You have drawn a: ";
  print_endline (string_of_card c);
  print_hands st';
  st'

let dealer_prompt st =
  ANSITerminal.print_string [ ANSITerminal.magenta ]
    "The Dealer is now playing...\n\n"

(** [stand_prompt st] is the new state resulting from the player playing the
    "stand" action. It also handles printing relevant information for the
    action. *)
let stand_prompt st =
  ANSITerminal.print_string [ ANSITerminal.magenta ]
    "\n\nStanding for your current hand...\n";
  let st' = stand st in
  if current_turn st' = Dealer then dealer_prompt st'
  else
    ANSITerminal.print_string [ ANSITerminal.yellow ]
      "Now playing your second hand...\n";
  print_hands st';
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
      | Hit -> (
          let st' = st |> hit_prompt in
          match check_status st' with
          | PrimHandLose ->
              let () = busted_prompt () in
              new_round_prompt st' |> main_prompt
          | BlackjackWin ->
              let () = blackjack_prompt () in
              new_round_prompt st' |> main_prompt
          | ContinueRound -> main_prompt st'
          | _ -> raise (Failure "Unimplemented"))
      | Stand -> stand_prompt st |> main_prompt
      | _ -> raise (Failure "Unimplemented")
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