type command =
  | Bet of int
  | Deposit of int
  | Hit
  | Stand
  | Double
  | Split
  | Surrender
  | Quit

exception Empty
exception Malformed

let rec remove_whitespace = function
  | [] -> []
  | h :: t -> if h = "" then remove_whitespace t else h :: remove_whitespace t

let strlist_to_int t = String.concat "" t |> int_of_string

let parse str =
  match String.split_on_char ' ' str |> remove_whitespace with
  | [] -> raise Empty
  | [ "hit" ] -> Hit
  | [ "stand" ] -> Stand
  | h :: t -> if h = "bet" then Bet (strlist_to_int t) else raise Malformed
