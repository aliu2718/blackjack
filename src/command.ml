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

(** [remove_whitespace] pattern matches to remove the white space from a string
    list. *)
let rec remove_whitespace = function
  | [] -> []
  | h :: t -> if h = "" then remove_whitespace t else h :: remove_whitespace t

(** [extract_int] pattern matches to extract the string representation of an int
    from options Bet and Deposit, then converting into an int. *)
let extract_int = function
  | [ x ] -> int_of_string x
  | [] -> raise Malformed
  | _ :: _ -> raise Malformed

let parse str =
  match String.split_on_char ' ' str |> remove_whitespace with
  | [] -> raise Empty
  | [ "hit" ] -> Hit
  | [ "stand" ] -> Stand
  | [ "quit" ] -> Quit
  | _ -> raise Malformed
