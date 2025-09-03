@target(erlang)
import cells/cell_erlang.{type Cell} as cells
@target(javascript)
import cells/cell_javascript.{type Cell} as cells

import cells/subscriber

pub fn make(value: a) -> Cell(a) {
  cells.make(value)
}

pub fn set(cell: Cell(a), value: a) -> Nil {
  cells.set(cell, value)
}

pub fn get(cell: Cell(a)) -> a {
  cells.get(cell)
}

pub fn update(cell: Cell(a), updater: fn(a) -> a) -> a {
  cells.update(cell, updater)
}

pub fn subscribe(
  cell: Cell(a),
  callback: fn(a) -> Nil,
) -> subscriber.UnsubCallback {
  cells.subscribe(cell, callback)
}
