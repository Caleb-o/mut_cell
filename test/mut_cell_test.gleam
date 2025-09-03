import cell
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn cell_setters_test() {
  let basic_cell = cell.make(10)
  assert cell.get(basic_cell) == 10

  cell.set(basic_cell, 20)

  assert cell.get(basic_cell) == 20
}

pub fn cell_updates_test() {
  let update_cell = cell.make(10)
  assert cell.get(update_cell) == 10

  let new_value = cell.update(update_cell, fn(value) { value * 2 })

  assert new_value == 20 && cell.get(update_cell) == 20
}
