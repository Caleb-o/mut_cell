@target(javascript)
import mut_cell/internal/subscriber

@target(javascript)
pub type Cell(a)

@target(javascript)
@external(javascript, "./cell.ffi.mjs", "make")
pub fn make(value: a) -> Cell(a)

@target(javascript)
@external(javascript, "./cell.ffi.mjs", "set")
pub fn set(cell: Cell(a), value: a) -> Nil

@target(javascript)
@external(javascript, "./cell.ffi.mjs", "get")
pub fn get(cell: Cell(a)) -> a

@target(javascript)
@external(javascript, "./cell.ffi.mjs", "update")
pub fn update(cell: Cell(a), updater: fn(a) -> a) -> a

@target(javascript)
@external(javascript, "./cell.ffi.mjs", "subscribe")
pub fn subscribe(
  cell: Cell(a),
  callback: fn(a) -> Nil,
) -> subscriber.UnsubCallback
