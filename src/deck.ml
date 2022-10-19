open Card

type t = Card.t list

let empty : t = []

let standard : t =
  [
    init_card Ace Spades [ 1; 11 ];
    init_card (Number 2) Spades [ 2 ];
    init_card (Number 3) Spades [ 3 ];
    init_card (Number 4) Spades [ 4 ];
    init_card (Number 5) Spades [ 5 ];
    init_card (Number 6) Spades [ 6 ];
    init_card (Number 7) Spades [ 7 ];
    init_card (Number 8) Spades [ 8 ];
    init_card (Number 9) Spades [ 9 ];
    init_card (Number 10) Spades [ 10 ];
    init_card Jack Spades [ 10 ];
    init_card Queen Spades [ 10 ];
    init_card King Spades [ 10 ];
    init_card Ace Hearts [ 1; 11 ];
    init_card (Number 2) Hearts [ 2 ];
    init_card (Number 3) Hearts [ 3 ];
    init_card (Number 4) Hearts [ 4 ];
    init_card (Number 5) Hearts [ 5 ];
    init_card (Number 6) Hearts [ 6 ];
    init_card (Number 7) Hearts [ 7 ];
    init_card (Number 8) Hearts [ 8 ];
    init_card (Number 9) Hearts [ 9 ];
    init_card (Number 10) Hearts [ 10 ];
    init_card Jack Hearts [ 10 ];
    init_card Queen Hearts [ 10 ];
    init_card King Hearts [ 10 ];
    init_card Ace Clubs [ 1; 11 ];
    init_card (Number 2) Clubs [ 2 ];
    init_card (Number 3) Clubs [ 3 ];
    init_card (Number 4) Clubs [ 4 ];
    init_card (Number 5) Clubs [ 5 ];
    init_card (Number 6) Clubs [ 6 ];
    init_card (Number 7) Clubs [ 7 ];
    init_card (Number 8) Clubs [ 8 ];
    init_card (Number 9) Clubs [ 9 ];
    init_card (Number 10) Clubs [ 10 ];
    init_card Jack Clubs [ 10 ];
    init_card Queen Clubs [ 10 ];
    init_card King Clubs [ 10 ];
    init_card Ace Diamonds [ 1; 11 ];
    init_card (Number 2) Diamonds [ 2 ];
    init_card (Number 3) Diamonds [ 3 ];
    init_card (Number 4) Diamonds [ 4 ];
    init_card (Number 5) Diamonds [ 5 ];
    init_card (Number 6) Diamonds [ 6 ];
    init_card (Number 7) Diamonds [ 7 ];
    init_card (Number 8) Diamonds [ 8 ];
    init_card (Number 9) Diamonds [ 9 ];
    init_card (Number 10) Diamonds [ 10 ];
    init_card Jack Diamonds [ 10 ];
    init_card Queen Diamonds [ 10 ];
    init_card King Diamonds [ 10 ];
  ]

let size (d : t) : int = List.length d
let add (d : t) (c : Card.t) : t = [ c ] @ d
let combine d1 d2 = raise (Failure "Unimplemented: Deck.combine")
let shuffle d = raise (Failure "Unimplemented: Deck.shuffle")

exception EmptyDeck

let peek d = raise (Failure "Unimplemented: Deck.peek")
let draw d n = raise (Failure "Unimplemented: Deck.draw")

let rec string_of_deck d =
  match d with
  | [] -> ""
  | h :: t -> Card.string_of_card h ^ " " ^ string_of_deck t
