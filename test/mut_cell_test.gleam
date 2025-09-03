import gleeunit
import mut_cell

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn cell_setters_test() {
  let basic_cell = mut_cell.make(10)
  assert mut_cell.get(basic_cell) == 10

  mut_cell.set(basic_cell, 20)

  assert mut_cell.get(basic_cell) == 20
}

pub fn cell_updates_test() {
  let update_cell = mut_cell.make(10)
  assert mut_cell.get(update_cell) == 10

  let new_value = mut_cell.update(update_cell, fn(value) { value * 2 })

  assert new_value == 20 && mut_cell.get(update_cell) == 20
}
