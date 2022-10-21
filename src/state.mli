(** Representation of dynamic Blackjack game

    This module represents the state of a Blackjack game as it is being played,
    including the current deck, the player's bets, available balance, and card
    hand, the dealer's hand, and functions that cause the state to change. *)

type h
(** The abstract type of values representing a Blackjack hand. *)

type t
(** The abstract type of values representing the Blackjack game state. *)

exception IllegalAction
(** Raised when an illegal action is taken in the Blackjack game state. *)

val empty_hand : h
(** [empty_hand] is a hand with no cards. *)

val init_state : t
(** [init_state] is the primitive Blackjack game state with no current hands, an
    empty deck, zero balance, and no bets. *)

val add_deck : t -> Deck.t -> t
(** [add_deck st d] adds [d] to the top of the current deck in [st], then
    shuffles the combined deck. *)

val deck_size : t -> int
(** [deck_size st] is the number of playing cards in the current deck in [st]. *)

val start_round : t -> t
(** [start_round st] is a new round of Blackjack with the player first receiving
    two cards from the top of the deck, then the dealer receiving one card from
    the top of the deck. If there are not enough cards in the deck to start the
    round, a standard 52-card deck is added to the existing deck (with
    shuffling) prior to distributing the cards to the hands. *)

val balance : t -> int
(** [balance st] is the current player balance. *)

val bet : t -> int -> t
(** [bet st n] is the resulting state after betting [n] on the current hand.
    Requires: [n] is non-negative. *)

val deposit : t -> int -> t
(** [deposit st n] is the resulting state after adding [n] to the current
    balance tracked by [st]. Requires: [n] is non-negative. *)

val current_bet : t -> int
(** [current_bet st] is the current bet on the current hand being played. *)

val current_hand : t -> h
(** [current_hand st] is the current hand being played, either by the player or
    by the dealer. *)

val player_hands : t -> h list
(** [player_hand st] is a list of the player's hand(s). *)

val dealer_hand : t -> h
(** [dealer_hand st] is the dealer's hand. *)

val hit : t -> t
(** [hit st] is the resulting state after choosing "hit" for the current hand
    (i.e., taking another card). *)

val stand : t -> t
(** [stand st] is the resulting state after choosing "stand" for the current
    hand (i.e., take no more cards). The current hand swaps to the next hand to
    play. *)

val double : t -> t
(** [double st] is the resulting state after choosing "double" for the current
    hand. The current hand takes exactly one more card, and the current bet on
    the hand is doubled. *)

val split : t -> t
(** [split st] is the resulting state after choosing "split" for the current
    hand. The starting hand with two cards is split into two separate hands,
    then each hand takes an extra card such that they both have two cards. The
    current hand switches to the newly created hand. Once a hand is split, the
    player can neither double nor split again, nor can they receive a Blackjack. *)

val surrender : t -> t
(** [surrender st] is the resulting state after choosing "surrender" for the
    current hand. Half of the current bet, rounded up, is forfeited, and the
    current hand ends immediately. *)

val hand_size : h -> int
(** [hand_size h] is the number of cards in hand [h]. *)

(** The type representing the best value of a Blackjack hand. *)
type value =
  | Blackjack
  | Value of int

val val_hand : h -> value
(** [val_hand h] is the current "best" value of hand [h]:

    - If [v] is the value of [h], then the result is [Value v]. If [h] has
      multiple possible values (i.e., [h] contains an Ace), [v] is the value
      maximum value less than or equal to 21, or if no such value exists, [v] is
      the minimum value.

    - If [h] is a Blackjack (i.e., [h] has size 2 and its value is exactly 21),
      then the result is [Blackjack]. *)

val string_of_hand : h -> string
(** [string_of_hand h] is the string representation of hand [h]. *)
