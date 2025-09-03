# mut_cell

[![Package Version](https://img.shields.io/hexpm/v/mut_cell)](https://hex.pm/packages/mut_cell)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/mut_cell/)
![Erlang-compatible](https://img.shields.io/badge/target-erlang-b83998)
![JavaScript-compatible](https://img.shields.io/badge/target-javascript-f1e05a)

This library offers an interior mutability system that manages internal state updates seamlessly, eliminating the need to recache values. Subscribers can register a callback function that is invoked whenever the cell is updated, receiving the new value for immediate use. Unsubscribing is straightforward; a function is provided upon subscription to easily stop receiving updates.

## Install
```sh
gleam add mut_cell@1
```
```gleam
import cell
import gleam/int
import gleam/io

pub fn main() -> Nil {
  // Create a cell
  let icell = cell.make(10)

  // Get the current value
  echo cell.get(icell)

  // Update a cell with a function
  echo cell.update(icell, fn(value) { value * 2 })

  // Create a callback
  let cb = fn(value) { io.println("New value set: " <> int.to_string(value)) }

  // Create a subscriber, which will call our callback
  let sub = cell.subscribe(icell, cb)

  // This operation (and update) will notify subscribers calling their callbacks
  cell.set(icell, 10)

  // Unsubscribe from the cell
  sub()

  // No notifications to send here
  cell.set(icell, 20)

  Nil
}
```

Further documentation can be found at <https://hexdocs.pm/mut_cell>.
