class SudokuGrid
  attr_reader :rows

  def initialize(string)
    @rows = string.split("\n").map{|row| row.scan(/\d/)}.select{|x| !x.empty?}
  end

  def self.from_values(values)
    self.new(values.each_slice(9).to_a.map(&:join).join("\n") ) 
  end

  def display 
    rows.each_slice(3).map do | group |
      group.map do | row |
        row.each_slice(3).map{|x| x.join(' ')}.join(' |')
      end.join("\n")
    end.join("\n------+------+------\n")
  end

  def columns 
    @columns ||= rows.transpose
  end

  def boxes 
    @boxes ||= rows.each_slice(3).map do |grouped_rows| 
                  grouped_rows.map{|row| row.each_slice(3).to_a }.transpose.map(&:flatten)
               end.flat_map(&:itself)
  end

  def all_values
    (1..9).map(&:to_s)
  end

  def possibilities(i, j)
    return [rows[i][j]] if rows[i][j] != '0'
    return (all_values - column_values(i,j) - row_values(i,j) - box_values(i,j))
  end

  def grid
    rows.map(&:join).join
  end

  private 
  
  def row_values(i,j)
    rows[i].select{|x| x != '0'}
  end

  def column_values(i,j)
    columns[j].select{|x| x != '0'}
  end

  def box_values(i, j)
    boxes[(i / 3) * 3 + j / 3 ].select{|x| x != '0'}
  end
end