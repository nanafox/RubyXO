#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'utilities'

BOARD = Board.new
PLAYER1 = Player.new('John', 'P')
PLAYER2 = Player.new('Sally', 'O')

Utilities.assert(
  PLAYER1 != PLAYER2,
  'Two players cannot have the same move character'
)

# Entry point for the game
def main
  Utilities.refresh_board

  loop do
    Utilities.register_move(PLAYER1, BOARD)
    break if Utilities.user_won?(PLAYER1)

    Utilities.register_move(PLAYER2, BOARD)
    break if Utilities.user_won?(PLAYER2)
  end

  main if Utilities.play_again? # Load the game again if user wants to play

  puts 'Thank you for playing the game ☺'
end

# Run the program
main if __FILE__ == $PROGRAM_NAME
