require "sudoku_grid"

describe SudokuGrid do
  it 'returns rows' do 
    file = File.read("spec/fixtures/easy.sudoku")

    validator = described_class.new(file)
    rows = validator.rows
    expect(rows.count).to eq(9)
    expect(rows[0]).to eq(["3", "0", "6", "0", "1", "5", "0", "0", "0"])
  end

  it 'returns columns' do 
    file = File.read("spec/fixtures/hard.sudoku")

    validator = described_class.new(file)
    columns = validator.columns
    expect(columns.count).to eq(9)
    expect(columns[0]).to eq(["4", "0", "0", "0", "0", "0", "0", "5", "1"])
  end

  it 'returns boxes' do 
    file = File.read("spec/fixtures/hard.sudoku")

    validator = described_class.new(file)
    boxes = validator.boxes
    expect(boxes.count).to eq(9)
    expect(boxes[0]).to eq(["4", "0", "0", "0", "3", "0", "0", "0", "0"])
  end

  it 'returns single possibility if cell is solved' do 
    file = File.read("spec/fixtures/hard.sudoku")

    sudoku = described_class.new(file)
   
    expect(sudoku.possibilities(0, 0) ).to eq(['4'])
    expect(sudoku.possibilities(0, 1) ).to eq(['1', '6', '7', '9'])
    expect(sudoku.possibilities(8, 8) ).to eq(['2', '3', '6', '8', '9'])
  end
end
