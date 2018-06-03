def grid(live_cells)
  live_cells
    .reduce({}) do |acc, cell|
      cell_neighbors(cell).each do |neighbor|
        acc[neighbor] = 0 unless acc.has_key?(neighbor)
      end
      acc[cell] = 1
      acc
    end
end

def cell_neighbors(cell)
  dimensions = cell.map { |coord| ((coord - 1)..(coord + 1)).to_a }
  dimensions[0]
    .product(*dimensions.drop(1))
    .reject { |neighbor_cell| neighbor_cell == cell }
end

# TODO: pass these rules in to revive?/survive?
def revive?(life_state, live_neighbors)
  life_state == 0 && live_neighbors >= 3 && live_neighbors <= 3
end

def survive?(life_state, live_neighbors)
  life_state == 1 && live_neighbors >= 2 && live_neighbors <= 3
end

# @return int
#   cell's state [life_state]
def evolve(cell, life_state, grid)
  neighbors = cell_neighbors(cell)
    .select { |neighbor| grid.has_key?(neighbor) && grid[neighbor] == 1 }
    .count

  return 1 if survive?(life_state, neighbors) || revive?(life_state, neighbors)
  return 0
end

# @return array
#   list of cells that lived to the next generation.
def advance(live_cells)
  grid = grid(live_cells)

  grid
    .reduce(grid.clone) do |acc, (cell, life_state)|
      acc[cell] = evolve(cell, life_state, grid)
      acc
    end
    .to_a
    .select { |_cell, life_state| life_state == 1 }
    .map(&:first)
end
