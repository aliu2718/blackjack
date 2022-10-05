open Card

type t = unit

let empty = raise (Failure "Umimplemented: Deck.empty")
let standard = raise (Failure "Unimplemented: Deck.standard")
let size d = raise (Failure "Unimplemented: Deck.size")
let add d c = raise (Failure "Unimplemented: Deck.add")
let combine d1 d2 = raise (Failure "Unimplemented: Deck.combine")
let shuffle d = raise (Failure "Unimplemented: Deck.shuffle")

exception EmptyDeck

let peek d = raise (Failure "Unimplemented: Deck.peek")
let draw d n = raise (Failure "Unimplemented: Deck.draw")