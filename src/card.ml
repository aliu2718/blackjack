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

let string_of_rank = function
  | Ace -> "Ace"
  | Number int -> string_of_int int
  | Jack -> "Jack"
  | Queen -> "Queen"
  | King -> "King"

let string_of_suit = function
  | Diamonds -> "Diamonds"
  | Hearts -> "Hearts"
  | Spades -> "Spades"
  | Clubs -> "Clubs"

let rec string_of_int_list values =
  "[" ^ String.concat "; " (List.map string_of_int values) ^ "]"

let string_of_card c = string_of_rank c.rank ^ " of " ^ string_of_suit c.suit