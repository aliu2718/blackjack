(** An engine for Blackjack strategies

    This module represents an engine that recommends the best moves for the
    current Blackjack game state based on Blackjack strategy charts for 4 to
    8-deck Blackjack games (dealer hits on Soft 17) and card counting
    strategies. *)

(** The type [move] represents a move in a Blackjack game the player can make. *)
type move =
  | Hit
  | Stand
  | Double
  | Split
  | Surrender

type t
(** The abstract type of values representing an evaluation of the game state,
    consisting of information such as the best move, factor at which to bet,
    number of cards/decks in the state, and card/true counts. *)

val update_evaluation_curr_round : State.t -> State.t
(** [update_evaluation_curr_round st] updates the stored evaluation based on
    [st]. The evaluation is updated everytime after a card is drawn and the
    round is being played on. The result is [st], which is left unchanged. *)

val update_evaluation_new_round : State.t -> State.t
(** [update_evaluation_new_round st] updates the stored evaluation based on
    [st]. The evaluation is updated everytime after a new round is started. The
    result is [st], which is left unchanged. *)

val update_evaluation_dealer : State.t -> State.t
(** [update_evaluation_dealer st] updates the stored evaluation based on [st].
    The evaluationis updated everytime after the dealer hits the deck during
    their turn. The result is [st], which is left unchanged. *)

val string_of_evaluation : unit -> string
(** [string_of_summary ()] is a string representation of the stored evaluation
    that is presentable to the player. *)
