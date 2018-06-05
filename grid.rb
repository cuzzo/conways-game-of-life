class CellState
  attr_accessor :alive

  def initialize(alive)
    @alive = alive
    @neighbors = 0
  end

  def touch()
    @neighbors += 1
  end

  # TODO: pass these rules in to revive?/survive?
  def revive?
    @alive == false && @neighbors >= 3 && @neighbors <= 3
  end

  def survive?
    @alive == true && @neighbors >= 2 && @neighbors <= 3
  end
end

def grid(live_cells)
  live_cells
    .reduce({}) do |acc, cell|
      cell_neighbors(cell).each do |neighbor|
        acc[neighbor] ||= CellState.new(false)
        acc[neighbor].touch()
      end
      acc[cell] ||= CellState.new(true)
      acc[cell].alive = true
      acc
    end
end

def cell_neighbors(cell)
  dimensions = cell.map { |coord| ((coord - 1)..(coord + 1)).to_a }
  dimensions[0]
    .product(*dimensions.drop(1))
    .reject { |neighbor_cell| neighbor_cell == cell }
end

# @return bool
#   cell's life state
def evolve(cell, state)
  return true if state.survive? || state.revive?
  return false
end

# @return array
#   list of cells that lived to the next generation.
def advance(live_cells)
  grid = grid(live_cells)

  grid
    .reduce({}) do |acc, (cell, state)|
      acc[cell] = evolve(cell, state)
      acc
    end
    .to_a
    .select { |_cell, life_state| life_state }
    .map(&:first)
end
