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

(** [lst_product lstlst] is a list of Cartesian products of the lists in
    [lstlst]. The order of the elements in each Cartesian product lst is not
    necessarily the same as the order of appearance in the lists in [lstlst]. *)
let lst_product lstlst =
  let prods = ref [ [] ] in
  List.iter
    (fun lst ->
      prods :=
        List.map (fun h -> List.map (fun p -> h :: p) !prods) lst
        |> List.flatten)
    lstlst;
  !prods

let val_hand h =
  if hand_size h = 0 then Value 0
  else
    let values_list = List.map (fun c -> values c) h in
    let values_product = lst_product values_list in
    let lte, gt =
      List.map (fun prod -> List.fold_left ( + ) 0 prod) values_product
      |> List.partition (fun v -> v <= 21)
    in
    if List.length lte <> 0 then
      let max_val = List.fold_left max (List.hd lte) (List.tl lte) in
      if max_val = 21 && hand_size h = 2 then Blackjack else Value max_val
    else Value (List.fold_left min (List.hd lte) (List.tl lte))

let rec string_of_hand h =
  match h with
  | [] -> ""
  | [ c ] -> Card.string_of_card c
  | c :: t -> Card.string_of_card c ^ ", " ^ string_of_hand t
