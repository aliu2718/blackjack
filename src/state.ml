open Card
open Deck

(** A type for representing the current turn. [Dealer] corresponds to the
    dealer's turn, [Player] corresponds to the player's turn playing their
    primary hand, and [PlayerSplit] corresponds to the player's turn playing
    their secondary hand resulting from the action of splitting. *)
type turn =
  | Dealer
  | Player
  | PlayerSplit

type h = Card.t list

type t = {
  deck : Deck.t;
  dealer_hand : h;
  player_hands : h * h;
  curr_turn : turn;
  curr_hand : h;
}

exception IllegalAction

let empty_hand = []

let init_state =
  {
    deck = empty;
    dealer_hand = empty_hand;
    player_hands = (empty_hand, empty_hand);
    curr_turn = Player;
    curr_hand = empty_hand;
  }

let add_deck st d = { st with deck = d |> combine st.deck |> shuffle }
let deck_size st = size st.deck

let rec start_round st =
  try
    let c1, d' = draw st.deck in
    let c2, d'' = draw d' in
    let dealer_card, new_deck = draw d'' in
    let new_player_hand = [ c1; c2 ] in
    {
      st with
      deck = new_deck;
      dealer_hand = [ dealer_card ];
      player_hands = (new_player_hand, empty_hand);
      curr_hand = new_player_hand;
    }
  with EmptyDeck -> start_round (add_deck st standard)

let balance st = raise (Failure "Unimplemented: State.balance")
let bet st n = raise (Failure "Unimplemented: State.bet")
let deposit st n = raise (Failure "Unimplemented: State.deposit")
let current_bet st = raise (Failure "Unimplemented: State.current_bet")
let current_hand st = st.curr_hand
let player_hands st = raise (Failure "Unimplemented: State.player_hands")
let dealer_hand st = st.dealer_hand
let hit st = raise (Failure "Unimplemented: State.hit")
let stand st = raise (Failure "Unimplemented: State.stand")
let double st = raise (Failure "Unimplemented: State.double")
let split st = raise (Failure "Unimplemented: State.split")
let surrender st = raise (Failure "Unimplemented: State.surrender")
let hand_size h = List.length h

type value =
  | Blackjack
  | Value of int

let val_hand h = raise (Failure "Unimplemented: State.val_hand")
let string_of_hand h = raise (Failure "Unimplemented: State.string_of_hand")