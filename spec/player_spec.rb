# frozen_string_literal: true

require "rspec"
require_relative "../lib/player"

RSpec.describe Player do
  subject(:player_o) { described_class.new("John", "O") }
  subject(:player_x) { described_class.new("Sally", "X") }

  describe "#initialize" do
    context "when the move character is incorrect" do
      let(:bad_character) { "P" }
      let(:expected_msg) do
        "Expected 'X' or 'O': Not #{bad_character.inspect}"
      end

      before do
        allow(described_class).to \
          receive(:new).with("Joe", bad_character)
                       .and_raise(ArgumentError, expected_msg)
      end

      it "raises an error" do
        expect { described_class.new("Joe", bad_character) }
          .to raise_error(ArgumentError, expected_msg)
      end

      it "sends the correct message" do
        expect { described_class.new("Joe", bad_character) }
          .to raise_error(expected_msg)
      end
    end

    context "when the move character is correct" do
      it "returns the correct move character" do
        expect(player_o.move_character).to eq("O")
        expect(player_x.move_character).to eq("X")
      end

      it "returns the correct name" do
        expect(player_o.name).to eq("John")
        expect(player_x.name).to eq("Sally")
      end

      it "returns the correct score" do
        expect(player_o.score).to eq(0)
        expect(player_x.score).to eq(0)
      end

      it "returns the correct games won" do
        expect(player_o.games_won).to eq(0)
        expect(player_x.games_won).to eq(0)
      end

      it "returns the correct games lost" do
        expect(player_o.games_lost).to eq(0)
        expect(player_x.games_lost).to eq(0)
      end

      it "returns the correct ties" do
        expect(player_o.ties).to eq(0)
        expect(player_x.ties).to eq(0)
      end
    end
  end

  describe "#total_games_played" do
    it "returns the correct number of games played" do
      expect(player_o.total_games_played).to eq(0)
    end

    it "returns the correct number of games played after a game" do
      player_o.games_won = 2
      player_o.games_lost = 1
      player_o.ties = 1

      expect(player_o.total_games_played).to eql(4)
    end
  end

  describe "#to_s" do
    it "returns the correct string representation of the player" do
      player_o.games_won = 2
      player_o.games_lost = 1
      player_o.ties = 1

      expect(player_o.to_s).to eql(
        "John - Score: 0 | Games Played: 4 | Wins: 2 | Losses: 1 | Ties: 1"
      )
    end
  end

  describe "#==" do
    it "returns false when the move characters are different" do
      expect(player_o == player_x).to be false
    end

    it "returns true when the move characters are the same" do
      # rubocop:disable Lint/BinaryOperatorWithIdenticalOperands
      expect(player_o == player_o).to be true
      # rubocop:enable Lint/BinaryOperatorWithIdenticalOperands
    end
  end
end
