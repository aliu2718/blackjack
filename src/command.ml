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

let parse str = raise (Failure "Unimplemented: Command.parse")