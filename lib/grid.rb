class Grid 
  attr_reader :values

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


  def initialize(values)
    @values = values
  end

  def solved?
    SQUARES.all?{|s| values[s].count == 1}
  end

  def most_constrained 
    SQUARES.map{|s| [values[s].count, s] if values[s].count > 1}.compact.min.last
  end

  def assign(s, d)
    other_values = values[s].reject{|v| v == d}

    if other_values.all?{|d2| eliminate( s, d2)}
      values
    else
      false
    end
  end


  def eliminate_peers( s, d)
    case values[s].count
    when 0
      false
    when 1
      d2 = values[s][0]
      PEERS[s].all?{|s2| eliminate( s2, d2)}
    else
      true
    end
  end

  def eliminate_units( s, d)
    UNITS[s].each do |units|
      dplaces = units.select{|u| values[u].include?(d)}
      case dplaces.count
      when 0
        return false ## Contradiction: no place for this value
      when 1
        # d can only be in one place in unit; assign it there
        next if dplaces[0] == s
        return false if !assign( dplaces[0], d)
      end
    end
  end

  def eliminate(s, d)
    return values if !values[s].include?(d) ## Already eliminated
    
    values[s] = values[s].reject{|x| x == d }
    
    eliminate_peers( s, d) && eliminate_units( s, d)
  end
  
  def dup 
    self.class.new(values.dup)
  end
end