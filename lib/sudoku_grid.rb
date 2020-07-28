class SudokuGrid
  attr_reader :rows

  def initialize(string)
    @rows = string.split("\n").map{|row| row.scan(/\d/)}.select{|x| !x.empty?}
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
    return (all_values - column(i,j).select{|x| x != '0'} - row(i,j).select{|x| x != '0'} - box(i,j).select{|x| x != '0'})
  end

  private 
  
  def row(i,j)
    rows[i]
  end

  def column(i,j)
    columns[j]
  end

  def box(i, j)
    boxes[(i / 3) * 3 + j / 3 ]
  end
end