require 'sudoku_grid'
require 'grid'
require 'pry'
class SudokuSolver
  
  ROWS     = 'ABCDEFGHI'.chars
  DIGITS   = '123456789'.chars
  COLS     = DIGITS
  SQUARES  = ROWS.product(DIGITS).map(&:join)

  UNITLIST = (COLS.map{|c| ROWS.product([c]).map(&:join)} +
              ROWS.map{|r| [r].product(COLS).map(&:join)} + 
              ['ABC','DEF','GHI'].map(&:chars).product(['123','456','789'].map(&:chars)).map{|x,y| x.product(y).map(&:join)}
              )
  UNITS = SQUARES.map{|s|  [s, UNITLIST.select{|u| u.include?(s)}]}.to_h
  PEERS = SQUARES.map{|s| [s, UNITS[s].flatten.uniq - [s] ] }.to_h

  def initialize(puzzle_string)
    @sudoku = SudokuGrid.new(puzzle_string)
  end

  def grid
    @sudoku.grid
  end

  def self.solve(puzzle_string)
    new(puzzle_string).solve
  end

  def parse_grid
    
    values = SQUARES.zip(grid_values).map{|s, v| [s, DIGITS] }.to_h
    g = Grid.new(values)
    grid_values.select{|s, d| DIGITS.include?(d) }.each do |s, d|
      return false if !g.assign( s, d)

    end
    values
  end

  def solve
    display( search(parse_grid) ) 
  end

  def display(values)
    @sudoku = SudokuGrid.from_values(values.values.map{|x| x.join }).display
  end

  def search(values)
    g = Grid.new(values)
    return false if !values
    
    return values if g.solved? ## Solved!
      
    s = g.most_constrained
    
    values[s].each do |d| 
      v = search(g.dup.assign(s, d))
      return v if v
    end
    false
  end

  def grid_values
    "Convert grid into a dict of {square: char} with '0' for empties."
    chars = grid.chars.select{|c| DIGITS.include?(c) || c == '0'}
    raise 'erro' if chars.count != 81
    SQUARES.zip(chars).to_h
  end

end
