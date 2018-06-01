#! /usr/bin/env ruby

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
  x, y = cell
  [
    [x - 1, y - 1],
    [x, y - 1],
    [x + 1, y - 1],
    [x - 1, y],
    [x + 1, y],
    [x - 1, y + 1],
    [x, y + 1],
    [x + 1, y + 1]
  ]
end

def underpopulated?(life_state, neighbors)
  return life_state == 1 && neighbors.count < 2
end

def overpopulated?(life_state, neighbors)
  return life_state == 1 && neighbors.count > 3
end

def revive?(life_state, neighbors)
  return life_state == 0 && neighbors.count == 3
end

def advance(live_cells)
  grid = grid(live_cells)

  grid
    .reduce(grid.clone) do |acc, (cell, life_state)|
      neighbors = cell_neighbors(cell).select { |neighbor| grid.has_key?(neighbor) && grid[neighbor] == 1 }
      if overpopulated?(life_state, neighbors) || underpopulated?(life_state, neighbors)
        acc[cell] = 0
      end
      if revive?(life_state, neighbors)
        acc[cell] = 1
      end
      acc
    end
    .to_a
    .select { |_cell, life_state| life_state == 1 }
    .map(&:first)
end

def render(cells)
  grid = cells.reduce({}) do |acc, cell|
    acc[cell] = 1
    acc
  end

  xs = cells.map { |x, y| x }
  ys = cells.map { |x, y| y }

  puts "---GENERATION---"
  puts "(#{xs.min},#{ys.min}) (#{xs.max},#{ys.max})"
  puts graph(grid, xs, ys)
end

def graph(grid, xs, ys)
  ((xs.min - 1)..(xs.max + 1)).to_a.reduce([]) do |acc, x|
    acc << ((ys.min - 1)..(ys.max + 1)).to_a.reduce("") do |bcc, y|
      bcc += grid.has_key?([x, y]) ? "X" : "O"
      bcc
    end
    acc
  end
end

def read_grid(file_path)
  File
    .read(file_path)
    .lines
    .map(&:chomp)
    .map { |line| line.split(',').map(&:to_i) }
end

def main()
  cells = read_grid(ARGV.first)

  while cells.count > 0
    render(cells)
    cells = advance(cells)
    STDIN.gets
  end
end

main()
