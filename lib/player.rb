#!/usr/bin/env ruby
# frozen_string_literal: true

# Class for Player
class Player
  attr_accessor :name, :score, :games_won, :games_lost, :move_character

  # Initialize a new player for the game
  # @param name The name of the player
  # @param move_character Either 'X' or 'O' character the uses chooses to be
  def initialize(name, move_character)
    @name = name

    unless %w[X O].include?(move_character.upcase)
      raise ArgumentError, \
            "Expected 'X' or 'O': Not #{move_character.inspect}"
    end

    @move_character = move_character
    @score = 0
    @games_lost = 0
    @games_won = 0
  end

  # Return the total number of games a user has played.
  # This is the combination of games the user has won or lost.
  def total_games_played
    @games_won + @games_lost
  end

  def to_s
    "Player name: #{name}\n" \
      "Total Score: #{score}\n" \
      "Total Games Played: #{total_games_played}\n" \
      "Games won: #{games_won}, Games lost: #{games_lost}"
  end

  # Check that two players in the same game don't have the move characters
  #   player1 = Player.new('John', 'O')
  #   player2 = Player.new('Sally', 'X')
  #
  #   player1 == player2    # => false
  #   player1 == player1    # => true
  def ==(other)
    @move_character == other.move_character
  end
end
