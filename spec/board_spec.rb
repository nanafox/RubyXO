# frozen_string_literal: true

# spec/board_spec.rb

require_relative "../lib/board"

RSpec.describe Board do
  subject(:board) { described_class.new }

  describe "#initialize" do
    it "initializes the board with empty fields" do
      expect(board.instance_variable_get(:@cells)).to eq([" "] * 9)
      expect(board.instance_variable_get(:@used_cells)).to eq(0)
    end
  end

  describe "#winning_combinations" do
    it "returns all possible winning combinations" do
      expect(board.winning_combinations).to contain_exactly(
        [board.instance_variable_get(:@cells)[0],
         board.instance_variable_get(:@cells)[1],
         board.instance_variable_get(:@cells)[2]],
        [board.instance_variable_get(:@cells)[3],
         board.instance_variable_get(:@cells)[4],
         board.instance_variable_get(:@cells)[5]],
        [board.instance_variable_get(:@cells)[6],
         board.instance_variable_get(:@cells)[7],
         board.instance_variable_get(:@cells)[8]],
        [board.instance_variable_get(:@cells)[0],
         board.instance_variable_get(:@cells)[3],
         board.instance_variable_get(:@cells)[6]],
        [board.instance_variable_get(:@cells)[1],
         board.instance_variable_get(:@cells)[4],
         board.instance_variable_get(:@cells)[7]],
        [board.instance_variable_get(:@cells)[2],
         board.instance_variable_get(:@cells)[5],
         board.instance_variable_get(:@cells)[8]],
        [board.instance_variable_get(:@cells)[0],
         board.instance_variable_get(:@cells)[4],
         board.instance_variable_get(:@cells)[8]],
        [board.instance_variable_get(:@cells)[2],
         board.instance_variable_get(:@cells)[4],
         board.instance_variable_get(:@cells)[6]]
      )
    end
  end

  describe "#to_s" do
    it "returns the string representation of the board" do
      expect(board.to_s).to eq(
        "   |   |   \n" \
          "---+---+---\n" \
          "   |   |   \n" \
          "---+---+---\n" \
          "   |   |   \n"
      )
    end
  end

  describe "#display" do
    it "prints the board" do
      expect { board.display }.to output(board.to_s).to_stdout
    end
  end

  describe "#tie?" do
    it "returns true if the board is full" do
      allow(board).to receive(:full?).and_return(true)
      expect(board).to be_tie
    end

    it "returns false if the board is not full" do
      allow(board).to receive(:full?).and_return(false)
      expect(board).not_to be_tie
    end
  end

  describe "#update" do
    context "when the move is valid" do
      it "updates the board with the move" do
        expect(board.update(1, "X")).to eq([true, nil])
        expect(board.instance_variable_get(:@cells)[0]).to eq("X")
        expect(board.instance_variable_get(:@used_cells)).to eq(1)
      end
    end

    context "when the move is invalid" do
      it "returns false and an error message" do
        allow(board).to receive(:valid_move?).and_return(
          [false, "Invalid move"]
        )
        expect(board.update(1, "X")).to eq([false, "Invalid move"])
      end
    end
  end

  describe "#reset" do
    it "resets the board" do
      board.update(1, "X")
      board.reset
      expect(board.instance_variable_get(:@cells)).to eq([" "] * 9)
      expect(board.instance_variable_get(:@used_cells)).to eq(0)
    end
  end

  describe "#winner_found?" do
    it "returns true and the winning character if a winner is found" do
      board.update(1, "X")
      board.update(2, "X")
      board.update(3, "X")
      expect(board.winner_found?).to eq([true, "X"])
    end

    it "returns false and nil if no winner is found" do
      expect(board.winner_found?).to eq([false, nil])
    end
  end

  describe "#valid_move?" do
    it "returns true if the move is valid" do
      expect(board.valid_move?(1, "X")).to be true
    end

    it "returns false and an error message if the board is full" do
      allow(board).to receive(:full?).and_return(true)
      expect(board.valid_move?(1, "X")).to eq(
        [false, "The board is already full"]
      )
    end

    it "returns false and an error message if the position is not an integer" do
      expect(board.valid_move?("a", "X")).to eq([false, "Expected an integer"])
    end

    it "returns false & an error message if the character is not 'X' or 'O'" do
      expect(board.valid_move?(1, "A")).to eq([false, "Expected 'X' or 'O'"])
    end

    it "returns false & an error message if the position is out of bounds" do
      expect(board.valid_move?(10, "X")).to eq(
        [false, "Allowed moves within cells 1 - 9"]
      )
    end

    it "returns false and an error message if the position is already filled" do
      board.update(1, "X")
      expect(board.valid_move?(1, "O")).to eq(
        [false, "This position is already filled. Try another spot."]
      )
    end
  end

  describe "#full?" do
    it "returns true if the board is full" do
      allow(board).to receive(:instance_variable_get).with(:@used_cells)
                                                     .and_return(9)
      board.instance_variable_set(:@used_cells, 9)
      expect(board).to be_full
    end

    it "returns false if the board is not full" do
      allow(board).to receive(:instance_variable_get).with(:@used_cells)
                                                     .and_return(0)
      expect(board).not_to be_full
    end
  end
end
