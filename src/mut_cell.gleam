import cell
import gleam/int
import gleam/io

pub fn main() -> Nil {
  let icell = cell.make(10)

  echo cell.get(icell)

  echo cell.update(icell, fn(value) { value * 2 })

  let cb = fn(value) { io.println("New value set: " <> int.to_string(value)) }

  let sub = cell.subscribe(icell, cb)

  cell.set(icell, 10)

  sub()

  cell.set(icell, 20)

  Nil
}
