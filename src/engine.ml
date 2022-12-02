type move =
  | Hit
  | Stand
  | Double
  | Split
  | Surrender

type t = {
  best_move : move;
  bet_size : float;
  deck_size : int;
  card_count : int;
  num_decks : float;
  true_count : float;
}

(** [hard_chart h dc] is [move] recommended by the 4-8 Decks, Dealer hits on
    Soft 17 Blackjack strategy chart (hard values) given player hand [h] and
    dealer card [dc]. *)
let hard_chart h dc = raise (Failure "Unimplemented: Engine.hard_chart")

(** [soft_chart h dc] is [move] recommended by the 4-8 Decks, Dealer hits on
    Soft 17 Blackjack strategy chart (soft values) given player hand [h] and
    dealer card [dc]. *)
let soft_chart h dc = raise (Failure "Unimplemented: Engine.shoft_chart")

(** [split_chart h dc] is [move] recommended by the 4-8 Decks, Dealer hits on
    Soft 17 Blackjack strategy chart (splitting) given player hand [h] and
    dealer card [dc]. *)
let split_chart h dc = raise (Failure "Unimplemented: Engine.split_chart")

(** [get_best_move st] is the best move for the player to make in [st] using the
    recommended moves in Blackjack strategy charts. *)
let get_best_move st = raise (Failure "Unimplemented: Engine.get_best_move")

let summary st = raise (Failure "Unimplemented: Engine.summary")

let string_of_summary s =
  raise (Failure "Unimplemented: Engine.string_of_summary")
