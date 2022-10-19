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

(** [string_of_rank r] is the string representation of rank [r]. *)
let string_of_rank = function
  | Ace -> "Ace"
  | Number int -> string_of_int int
  | Jack -> "Jack"
  | Queen -> "Queen"
  | King -> "King"

(** [string_of_suit s] is the string representation of suit [s]. *)
let string_of_suit = function
  | Diamonds -> "Diamonds"
  | Hearts -> "Hearts"
  | Spades -> "Spades"
  | Clubs -> "Clubs"

(** [string_of_int_list lst] is the string representation of list [lst]. *)
let rec string_of_int_list lst =
  "[" ^ String.concat "; " (List.map string_of_int lst) ^ "]"

let string_of_card c =
  string_of_rank (rank c) ^ " of " ^ string_of_suit (suit c)
