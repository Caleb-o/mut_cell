@target(erlang)
import cells/subscriber
@target(erlang)
import gleam/dict.{type Dict}

@target(erlang)
import gleam/erlang/atom
@target(erlang)
import gleam/erlang/process.{type Subject}
@target(erlang)
import gleam/otp/actor

@target(erlang)
@external(erlang, "erlang", "unique_integer")
fn unique_integer(opts: List(atom)) -> Int

@target(erlang)
type State(a) {
  State(value: a, subscribers: Dict(Int, fn(a) -> Nil))
}

@target(erlang)
pub opaque type Cell(a) {
  Cell(value: Subject(Message(a)))
}

@target(erlang)
type Message(a) {
  Get(reply: Subject(a))
  Set(a)
  Update(cb: fn(a) -> a)
  AddSubscriber(id: Int, cb: fn(a) -> Nil, reply: Subject(Nil))
  RemoveSubscriber(id: Int, reply: Subject(Nil))
}

@target(erlang)
pub fn make(value: a) -> Cell(a) {
  let assert Ok(actor) =
    actor.new(State(value, dict.new()))
    |> actor.on_message(handle_message)
    |> actor.start

  Cell(actor.data)
}

@target(erlang)
pub fn set(cell: Cell(a), value: a) -> Nil {
  process.send(cell.value, Set(value))
}

@target(erlang)
pub fn get(cell: Cell(a)) -> a {
  process.call(cell.value, 10, Get)
}

@target(erlang)
pub fn update(cell: Cell(a), updater: fn(a) -> a) -> a {
  process.send(cell.value, Update(updater))

  process.call(cell.value, 10, Get)
}

@target(erlang)
pub fn subscribe(
  cell: Cell(a),
  callback: fn(a) -> Nil,
) -> subscriber.UnsubCallback {
  let id = unique_integer([atom.create("monotonic"), atom.create("positive")])

  // Tell the actor to add this subscriber
  process.call(cell.value, 10, AddSubscriber(id, callback, _))

  // Return an unsubscribe function
  fn() { process.call(cell.value, 10, RemoveSubscriber(id, _)) }
}

@target(erlang)
fn handle_message(
  state: State(a),
  message: Message(a),
) -> actor.Next(State(a), b) {
  case message {
    Get(client) -> {
      process.send(client, state.value)
      actor.continue(state)
    }

    Set(value) -> {
      dict.each(state.subscribers, fn(_, cb) { cb(value) })
      actor.continue(State(value, state.subscribers))
    }

    Update(cb) -> {
      let new_value = cb(state.value)
      dict.each(state.subscribers, fn(_, cb) { cb(new_value) })
      actor.continue(State(new_value, state.subscribers))
    }

    AddSubscriber(id:, cb:, reply:) -> {
      let new_subs = dict.insert(state.subscribers, id, cb)
      process.send(reply, Nil)
      actor.continue(State(state.value, new_subs))
    }

    RemoveSubscriber(id:, reply:) -> {
      let new_subs = dict.delete(state.subscribers, id)
      process.send(reply, Nil)
      actor.continue(State(state.value, new_subs))
    }
  }
}
