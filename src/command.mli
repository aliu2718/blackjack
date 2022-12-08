(** Parsing of player commands. *)

(** The type [command] represents a player command that is decomposed into an
    action and possibly an integer amount. Invariant: the [int] carried by [Bet]
    and [Deposit] are non-negative. *)
type command =
  | Bet of int
  | Deposit of int
  | Hit
  | Stand
  | Double
  | Split
  | Surrender
  | Evaluate
  | Quit

exception Empty
(** Raised when an empty command is parsed. *)

exception Malformed
(** Raised when a malformed command is parsed. *)

val parse : string -> command
(** [parse str] parses a player's input into a [command], as follows. The first
    word (i.e., consecutive sequence of non-space characters) of [str] becomes
    the action. The following integer, if any, becomes the integer amount.
    Examples:

    - [parse "    bet   500   "] is [Bet 500]
    - [parse "deposit   32"] is [Deposit 32]
    - [parse "      double"] is [Double]
    - [parse "quit"] is [Quit]

    Requires: [str] contains only alphanumeric (A-Z, a-z, 0-9) and space
    characters (only ASCII character code 32; not tabs or newlines, etc.).

    Raises: [Empty] if [str] is the empty string or contains only spaces.

    Raises: [Malformed] if the command is malformed. A command is malformed if
    the action is neither "bet", "deposit", "hit", "stand", "double", "split",
    "surrender", "evaluate", nor "quit", or if the action is "bet" or "deposit"
    and there is a non-integer afterwards, or if the action is "bet" or
    "deposit" and there are multiple integers afterwards, or if the action is
    one of the other six and there is/are non-space character(s) afterwards. *)
