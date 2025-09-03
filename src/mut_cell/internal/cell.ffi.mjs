export function make(value) {
  return { value, subscribers: {} }
}

export function set(cell, value) {
  cell.value = value;

  Object.values(cell.subscribers || {}).forEach((sub) => {
    sub.callback(value);
  });
}

export function get(cell) {
  return cell.value;
}

export function update(cell, update) {
  const new_value = update(cell.value);
  cell.value = new_value;

  Object.values(cell.subscribers || {}).forEach((sub) => {
    sub.callback(new_value);
  });

  return new_value;
}

export function subscribe(cell, callback) {
  // Might need a better ID
  const cell_id = `${Date.now()}`;
  cell.subscribers[cell_id] = {
    callback,
  };

  return () => {
    delete cell.subscribers[cell_id];
  };
}