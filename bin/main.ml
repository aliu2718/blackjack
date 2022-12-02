open Blackjack.Card
open Blackjack.Command
open Blackjack.Deck
open Blackjack.State

(** [count] is the number of rounds that have been played. *)
let count = ref 0

(** [wins] is the number of wins the player has. *)
let wins = ref 0

(** [losses] is the number of losses the player has. *)
let losses = ref 0

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
  let p1, p2 = player_hands st in
  let d_hand = dealer_hand st in
  ANSITerminal.print_string [ ANSITerminal.yellow ] "The Dealer's hand is: ";
  let dealer_value =
    if val_hand d_hand = Blackjack then Value 21 else val_hand d_hand
  in
  print_endline
    (string_of_hand d_hand ^ "  (Current Value: "
    ^ string_of_value dealer_value
    ^ ")");
  match p2 = empty_hand with
  | true ->
      ANSITerminal.print_string [ ANSITerminal.yellow ] "Your hand is: ";
      print_endline
        (string_of_hand p1 ^ "  (Current Value: "
        ^ string_of_value (val_hand p1)
        ^ ")")
  | false ->
      ANSITerminal.print_string [ ANSITerminal.yellow ] "Your hands are:\n";
      print_endline
        ("[Primary Hand] " ^ string_of_hand p1 ^ "  (Current Value: "
        ^ string_of_value (val_hand p1)
        ^ ")");
      print_endline
        ("[Split Hand] " ^ string_of_hand p2 ^ "  (Current Value: "
        ^ string_of_value (val_hand p2)
        ^ ")")

(** [busted_prompt ()] prints a prompt for when the player busts their hand. *)
let busted_prompt () =
  ANSITerminal.print_string [ ANSITerminal.red ] "\nYour hand was a bust!\n";
  incr losses;
  ANSITerminal.print_string [ ANSITerminal.yellow ]
    "Starting a new round...\n\n"

(** [blackjack_prompt ()] prints a prompt for when the player hits a Blackjack. *)
let blackjack_prompt () =
  ANSITerminal.print_string [ ANSITerminal.green ] "\nYou hit a Blackjack!\n";
  incr wins;
  ANSITerminal.print_string [ ANSITerminal.yellow ]
    "Starting a new round...\n\n"

let rec bet_prompt st =
  print_string "\nYour current balance is: ";
  ANSITerminal.print_string [ ANSITerminal.blue ]
    ("$" ^ string_of_int (balance st) ^ ".\n\n");
  print_endline "How much would you like to bet? Enter an integer.";
  print_string "> ";
  match int_of_string (read_line ()) with
  | x ->
      ANSITerminal.print_string [ ANSITerminal.red ]
        ("\nYou have $"
        ^ string_of_int (bet st x |> balance)
        ^ " remaining.\n\n")
  | exception _ ->
      ANSITerminal.print_string [ ANSITerminal.red ]
        "\nYou have entered an invalid value. Please try again.\n\n";
      bet_prompt st

(** [new_round_prompt st] is the new state resulting from starting a new round.
    It also handles start the round and provides information about the new
    round, i.e. dealing new cards to a fresh hand to the player and dealer, and
    informing the player of their hand, the dealer's hand, and the values. *)
let rec new_round_prompt st =
  bet_prompt st;
  incr count;
  ANSITerminal.print_string [ ANSITerminal.magenta ] "\nDealing new cards for ";
  ANSITerminal.print_string [ ANSITerminal.yellow ]
    ("round " ^ string_of_int !count ^ "\n");
  ANSITerminal.print_string [ ANSITerminal.green ]
    ("Wins: " ^ string_of_int !wins ^ "\n");
  ANSITerminal.print_string [ ANSITerminal.red ]
    ("Losses: " ^ string_of_int !losses ^ "\n\n");
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
  ANSITerminal.print_string [ ANSITerminal.yellow ] "You have drawn: ";
  print_endline (string_of_card c);
  print_hands st';
  st'

(** [dealer_end_prompt st] prints the prompt corresponding to the current state
    of the Blackjack game after the dealer has finished playing their turn. *)
let dealer_end_prompt st =
  match check_status st with
  | PlayerWin | PrimHandWin ->
      ANSITerminal.print_string [ ANSITerminal.green ]
        "\nYou won! Your hand was better than the Dealer's this round!\n";
      incr wins;
      ANSITerminal.print_string [ ANSITerminal.yellow ]
        "Starting a new round...\n\n"
  | DealerWin ->
      ANSITerminal.print_string [ ANSITerminal.red ]
        "\nYou lost. The Dealer's hand was better than your hand this round.\n";
      incr losses;
      ANSITerminal.print_string [ ANSITerminal.yellow ]
        "Starting a new round...\n\n"
  | _ -> raise (Failure "Unimplemented")

(** [dealer_prompt st] is the new state resulting from the dealer playing. It
    also handles printing relevant information for the dealer's turn. *)
let dealer_prompt st =
  ANSITerminal.print_string [ ANSITerminal.magenta ]
    "The Dealer is now playing...\n\n";
  let st' = dealer_play st in
  print_hands st';
  dealer_end_prompt st';
  st'

(** [stand_prompt st] is the new state resulting from the player playing the
    "stand" action. It also handles printing relevant information for the
    action. *)
let stand_prompt st =
  ANSITerminal.print_string [ ANSITerminal.magenta ]
    "\nStanding for your current hand...\n";
  let st' = stand st in
  if current_turn st' = Dealer then dealer_prompt st'
  else
    let () =
      ANSITerminal.print_string [ ANSITerminal.yellow ]
        "Now playing your second hand...\n"
    in
    print_hands st';
    st'

(** [main_prompt st] handles the player's inputs and prints the appropriate
    prompts corresponding to the parsed inputs. *)
let rec main_prompt st =
  print_string "\nYour valid actions are: ";
  ANSITerminal.print_string [ ANSITerminal.yellow ] "| hit | stand | quit |\n";
  print_endline "What would you like to do?";
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
      | Stand -> stand_prompt st |> new_round_prompt |> main_prompt
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

(* Execute the Blackjack game session. *)
let () = main ()