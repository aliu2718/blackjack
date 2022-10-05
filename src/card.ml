type rank =
  | Ace
  | Number of int
  | Jack
  | Queen
  | King

type suit =
  | Diamonds
  | Hearts
  | Spades
  | Clubs

type t = unit

let init_card r s v = raise (Failure "Unimplemented: Card.init_card")
let rank c = raise (Failure "Unimplemented: Card.rank")
let suit c = raise (Failure "Unimplemented: Card.suit")
let values c = raise (Failure "Unimplemented: Card.values")
let string_of_card c = raise (Failure "Unimplemented: Card.string_of_card")