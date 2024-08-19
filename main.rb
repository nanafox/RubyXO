#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/board'
require_relative 'lib/player'
require_relative 'lib/utilities'

BOARD = Board.new
PLAYER1 = Player.new('John', 'X')
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

  # Load the game once more if the user chooses to continue playing
  BOARD.reset and main if Utilities.play_again?

  puts 'Thank you for playing the game ☺'
  exit(0)
end

# Run the program
main if __FILE__ == $PROGRAM_NAME
