# mut_cell

[![Package Version](https://img.shields.io/hexpm/v/mut_cell)](https://hex.pm/packages/mut_cell)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/mut_cell/)

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
