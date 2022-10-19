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

type t = {
  rank : rank;
  suit : suit;
  values : int list;
}

let init_card r s v = { rank = r; suit = s; values = v }
let rank c = c.rank
let suit c = c.suit
let values c = c.values
let string_of_card c = raise (Failure "Unimplemented: Card.string_of_card")