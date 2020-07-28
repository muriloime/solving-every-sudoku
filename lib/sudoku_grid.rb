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
end