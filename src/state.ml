type h = unit
type t = unit

exception IllegalAction

let init_state = raise (Failure "Unimplemented: State.init_state")
let balance st = raise (Failure "Unimplemented: State.balance")
let bet st n = raise (Failure "Unimplemented: State.bet")
let deposit st n = raise (Failure "Unimplemented: State.deposit")
let current_bet st = raise (Failure "Unimplemented: State.current_bet")
let current_hand st = raise (Failure "Unimplemented: State.current_hand")
let player_hands st = raise (Failure "Unimplemented: State.player_hands")
let dealer_hand st = raise (Failure "Unimplemented: State.dealer_hand")
let hit st = raise (Failure "Unimplemented: State.hit")
let stand st = raise (Failure "Unimplemented: State.stand")
let double st = raise (Failure "Unimplemented: State.double")
let split st = raise (Failure "Unimplemented: State.split")
let surrender st = raise (Failure "Unimplemented: State.surrender")

type value =
  | Blackjack
  | Value of int

let val_hand h = raise (Failure "Unimplemented: State.val_hand")
let string_of_hand h = raise (Failure "Unimplemented: State.string_of_hand")