open Card

type t = Card.t list

let empty : t = []
let standard = []
let size d = raise (Failure "Unimplemented: Deck.size")
let add d c = raise (Failure "Unimplemented: Deck.add")
let combine d1 d2 = raise (Failure "Unimplemented: Deck.combine")
let shuffle d = raise (Failure "Unimplemented: Deck.shuffle")

exception EmptyDeck

let peek d = raise (Failure "Unimplemented: Deck.peek")
let draw d n = raise (Failure "Unimplemented: Deck.draw")

let rec string_of_deck d =
  match d with
  | [] -> ""
  | h :: t -> Card.string_of_card h ^ string_of_deck t
