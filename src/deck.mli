(** Representation of playing card deck.

    This module represents a deck of playing cards and handles operations for a
    deck including initialization, shuffling, peeking the top card, and drawing. *)

type t
(** The abstract type of values representing a deck of playing cards. *)

val empty : t
(** [empty] is a deck with no playing cards. *)

val standard : t
(** [standard] is a standard 52-card deck. *)

val size : t -> int
(** [size d] is the number of playing cards in deck [d]. *)

val add : t -> Card.t -> t
(** [add d c] is the resulting deck after putting playing card [c] on the top of
    deck [d]. *)

val combine : t -> t -> t
(** [combine d1 d2] is the resulting deck after putting [d2] on the top of [d1]. *)

val shuffle : t -> t
(** [shuffle d] is deck [d] with all cards shuffled to a random order. *)

exception EmptyDeck
(** Raised when attempting to interact with a card in an empty deck. *)

val peek : t -> Card.t
(** [peek d] is the top card of deck [d].

    Raises: [EmptyDeck] if [d] is an empty deck. *)

val draw : t -> int -> Card.t * t
(** [draw d n] is the pair consisting of the top [n] cards of [d] and the new
    deck with those top cards removed. Essentially, [n] cards are drawn from the
    top of [d] to result in a new deck.

    Requires: n is non-negative.

    Raises: [EmptyDeck] if [d] is an empty deck and [n] > 0. *)