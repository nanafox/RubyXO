# frozen_string_literal: true

require "rspec"
require_relative "../lib/game"
require_relative "../lib/board"
require_relative "../lib/player"

RSpec.describe Game do
  subject(:game) { described_class.new }

  let(:player_x) do
    Player.new("Player X", "X")
  end

  let(:player_o) do
    Player.new("Player O", "O")
  end

  let(:board) { Board.new }

  before do
    allow(game).to receive(:gets).and_return("Player X", "Player O")
    allow(game).to receive(:create_players).and_return([player_x, player_o])
    allow(game).to receive(:game_board).and_return(board)
    allow(board).to receive(:reset)
    allow(board).to receive(:display)
    allow(game).to receive(:refresh_board)
    allow(game).to receive(:play_game)
    allow(game).to receive(:score_board)
    allow(game).to receive(:play_again?).and_return(false)
    allow(game).to receive(:exit)
  end

  describe "#start" do
    context "when the game starts" do
      it "creates two players" do
        expect(game).to receive(:create_players).once
        game.start
      end

      it "creates a new game board" do
        expect(game).to receive(:game_board)
        game.start
      end

      it "plays the game" do
        expect(game).to receive(:play_game)
        game.start
      end

      it "prints the score board" do
        expect(game).to receive(:score_board)
        game.start
      end

      it "asks if the player wants to play again" do
        allow(game).to receive(:play_again?).and_return(false)
        expect(game).to receive(:play_again?).and_return(false)
        game.start
      end
    end

    context "when the player wants to play again" do
      before do
        allow(game).to receive(:play_again?).and_return(true, false)
      end

      it "resets the board" do
        expect(board).to receive(:reset)
        game.start
      end
    end

    context "when the the player object is invalid" do
      before do
        allow(game).to receive(:create_players).and_return(
          ["invalid", player_o]
        )
      end

      it "causes #valid_input? to return false" do
        result = game.valid_input?("invalid", board)

        expect(result[:valid]).to be false
        expect(result[:message]).to eq("Invalid Player object")
      end

      it "exits the game with an error message" do
        expect do
          game.start
        end.to output(/Invalid Player object/).to_stdout

        expect(board).not_to receive(:reset)
        expect(game).not_to receive(:refresh_board)
      end
    end

    context "when the board object is invalid" do
      before do
        allow(game).to receive(:game_board).and_return("invalid_board")
      end

      it "causes #valid_input? to return false" do
        result = game.valid_input?(player_x, "invalid")

        expect(result[:valid]).to be false
        expect(result[:message]).to eq("Invalid Board object")
      end

      it "exits the game with an error message" do
        expect do
          game.start
        end.to output(/Invalid Board object/).to_stdout

        expect(board).not_to receive(:reset)
        expect(game).not_to receive(:refresh_board)
      end
    end

    context "when the game ends" do
      it "exits the game with a thank you message" do
        allow(game).to receive(:play_again?).and_return(false)
        expect do
          game.start
        end.to output(/Thank you for playing the game ☺/).to_stdout

        expect(board).not_to receive(:reset)
        expect(game).not_to receive(:refresh_board)
      end
    end
  end

  describe "#valid_input?" do
    context "when the input is invalid" do
      it "returns false for an invalid board object" do
        result = game.valid_input?(player_x, "invalid")

        expect(result[:valid]).to be false
        expect(result[:message]).to eq("Invalid Board object")
      end

      it "returns false for an invalid player object" do
        result = game.valid_input?("invalid", board)

        expect(result[:valid]).to be false
        expect(result[:message]).to eq("Invalid Player object")
      end
    end

    context "when the input is valid" do
      it "returns true" do
        result = game.valid_input?(player_x, board)

        expect(result[:valid]).to be true
      end
    end
  end

  describe "#register_move" do
    let(:player) { player_x }

    before do
      game.start
    end

    context "when the move is valid" do
      before do
        allow(game).to receive(:player_move).and_return(1)
        allow(board).to receive(:update).and_return([true, nil])
      end

      it "updates the board" do
        expect(board).to receive(:update).with(1, "X")
        game.register_move(player)
      end

      it "refreshes the board" do
        expect(game).to receive(:refresh_board)
        game.register_move(player)
      end
    end

    context "when the move is invalid" do
      before do
        allow(game).to receive(:player_move).and_return(1)
        allow(board).to receive(:update).and_return(
          [false, "Invalid move"], [true, nil]
        )
      end

      it "displays an error message" do
        expect do
          game.register_move(player)
        end.to output(/Invalid move/).to_stdout
      end

      it "asks for a valid move" do
        expect(game).to receive(:register_move).with(player)
        game.register_move(player)
      end
    end
  end
end
