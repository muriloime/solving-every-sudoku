require 'sudoku_grid'
require 'pry'
class SudokuSolver
  
  DIGITS   = '123456789'.chars
  ROWS     = 'ABCDEFGHI'.chars
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
    grid_values.each do |s, d|
      return false if DIGITS.include?(d) && !assign(values, s, d)
    end
    values
  end

  def solve
    display( search(parse_grid) ) 
  end

  def display(values)
    # binding.pry
    @sudoku = SudokuGrid.from_values(values.values.map{|x| x.join }).display
  end

  def search(values)
    "Using depth-first search and propagation, try all possible values."
    return false if !values # Failed earlier
    
    return values if SQUARES.all?{|s| values[s].count == 1} ## Solved!
      
    ## Chose the unfilled square s with the fewest possibilities
    n,s = SQUARES.map{|s| [values[s].count, s] if values[s].count > 1}.compact.min
    
    return values if values[s].find{|d| search(assign(values.dup, s, d))}
  end

    
  def assign(values, s, d)
    """Eliminate all the other values (except d) from values[s] and propagate.
    Return values, except return False if a contradiction is detected."""
    
    other_values = values[s].reject{|v| v == d}

    if other_values.all?{|d2| eliminate(values, s, d2)}
      values
    else
      false
    end 
  end 

  def grid_values
    "Convert grid into a dict of {square: char} with '0' for empties."
    chars = grid.chars.select{|c| DIGITS.include?(c) || c == '0'}
    raise 'erro' if chars.count != 81
    SQUARES.zip(chars).to_h
  end

  def eliminate(values, s, d)
    """Eliminate d from values[s]; propagate when values or places <= 2.
    Return values, except return False if a contradiction is detected."""
    
    return values if !values[s].include?(d) ## Already eliminated
    
    values[s] = values[s].reject{|x| x == d }
    
    case values[s].count
    when 0
      return false
    when 1
      d2 = values[s][0]
      return false if !PEERS[s].all?{|s2| eliminate(values, s2, d2)}
    end
    
    UNITS[s].each do |units|
      dplaces = units.select{|u| values[u].include?(d)}
      case dplaces.count
      when 0
        return false ## Contradiction: no place for this value
      when 1
        # d can only be in one place in unit; assign it there
        return false if !assign(values, dplaces[0], d)
      end
    end
  end
end
