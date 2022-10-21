open Card
open Deck

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
}

exception IllegalAction

let empty_hand = []

let init_state =
  {
    deck = empty;
    dealer_hand = empty_hand;
    player_hands = (empty_hand, empty_hand);
    curr_turn = Player;
  }

let add_deck st d = { st with deck = d |> combine st.deck |> shuffle }

let load_state =
  let () = Random.self_init () in
  let rand_int = 1 + Random.int 9 in
  let primary_deck =
    List.fold_left combine empty (Array.make rand_int standard |> Array.to_list)
  in
  primary_deck |> add_deck init_state

let deck_size st = size st.deck

(** [draw_card st] is a pair containing the card draw from the deck in [st] and
    the resulting state. If there are no cards in the deck to be drawn, a
    52-card standard deck is added to [st] and shuffled prior to drawing a card. *)
let rec draw_card st =
  try
    let c, d' = draw st.deck in
    (c, { st with deck = d' })
  with EmptyDeck -> draw_card (add_deck st standard)

let rec start_round st =
  let c1, st' = draw_card st in
  let c2, st'' = draw_card st' in
  let dealer_card, new_state = draw_card st'' in
  let new_player_hand = [ c1; c2 ] in
  {
    new_state with
    dealer_hand = [ dealer_card ];
    player_hands = (new_player_hand, empty_hand);
    curr_turn = Player;
  }

(** [change_turn st] changes the turn (the resulting state with the new
    appropriate turn). *)
let change_turn st =
  match st.curr_turn with
  | Dealer -> { st with curr_turn = Player }
  | Player ->
      if snd st.player_hands <> empty_hand then { st with curr_turn = Dealer }
      else { st with curr_turn = PlayerSplit }
  | PlayerSplit -> { st with curr_turn = Dealer }

let balance st = raise (Failure "Unimplemented: State.balance")
let bet st n = raise (Failure "Unimplemented: State.bet")
let deposit st n = raise (Failure "Unimplemented: State.deposit")
let current_bet st = raise (Failure "Unimplemented: State.current_bet")
let current_turn st = st.curr_turn

let current_hand st =
  match st.curr_turn with
  | Dealer -> st.dealer_hand
  | Player -> fst st.player_hands
  | PlayerSplit -> snd st.player_hands

let player_hands st = st.player_hands
let dealer_hand st = st.dealer_hand

let hit st =
  let c, st' = draw_card st in
  match st.curr_turn with
  | Dealer -> (c, { st' with dealer_hand = st.dealer_hand @ [ c ] })
  | Player ->
      ( c,
        {
          st' with
          player_hands = (fst st'.player_hands @ [ c ], snd st.player_hands);
        } )
  | PlayerSplit ->
      ( c,
        {
          st' with
          player_hands = (fst st.player_hands, snd st.player_hands @ [ c ]);
        } )

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
    else Value (List.fold_left min (List.hd gt) (List.tl gt))

type status =
  | DealerWin
  | PlayerWin
  | PrimHandWin
  | SecHandWin
  | PrimHandLose
  | SecHandLose
  | BlackjackWin
  | ContinueRound

(** [compare_val v1 v2] compares two values [v1] and [v2], and is positive if v1
    is of higher value than v2, negative if v1 is of lower value than v2, and
    zero if v1 is of equal value than v2. *)
let compare_val v1 v2 =
  match v1 with
  | Value v1' -> begin
      match v2 with
      | Value v2' ->
          if v1' > v2' then v1' - v2' else if v2' > v1' then v1' - v2' else 0
      | Blackjack -> -1
    end
  | Blackjack -> begin
      match v2 with
      | Value v2' -> 1
      | Blackjack -> 0
    end

let check_status st =
  let curr_turn = st.curr_turn in
  if curr_turn <> Dealer then
    match val_hand (current_hand st) with
    | Value v ->
        if v > 21 then if curr_turn = Player then PrimHandLose else SecHandLose
        else ContinueRound
    | Blackjack ->
        if snd st.player_hands = empty_hand then BlackjackWin else ContinueRound
  else
    let v1, v2, v =
      ( val_hand (fst st.player_hands),
        val_hand (snd st.player_hands),
        val_hand st.dealer_hand )
    in
    if compare_val v (Value 21) > 0 then PlayerWin
    else if compare_val v (Value 17) >= 0 then
      if compare_val v v1 >= 0 && compare_val v v2 >= 0 then DealerWin
      else if compare_val v v1 >= 0 then SecHandWin
      else if compare_val v v2 >= 0 then PrimHandWin
      else PlayerWin
    else ContinueRound

let string_of_value v =
  match v with
  | Blackjack -> "Blackjack"
  | Value n -> string_of_int n

let rec string_of_hand h =
  match h with
  | [] -> ""
  | [ c ] -> Card.string_of_card c
  | c :: t -> Card.string_of_card c ^ ", " ^ string_of_hand t
