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
(** The abstract type of values representing a summary of the game state,
    consisting of information such as the best move, factor at which to bet,
    number of cards/decks in the state, and card/true counts. *)

val summary : State.t -> t
(** [summary st] is a summary of the game state with helpful information. *)

val string_of_summary : t -> string
(** [string_of_summary s] is a string representation of [s] that is presentable
    to the player. *)
