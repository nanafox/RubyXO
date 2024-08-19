# frozen_string_literal: true

require 'colorize'

# Utility module.
module Utilities
  # A simple function to verify that a condition is met
  def self.assert(condition, message = 'Assertion failed!')
    raise message unless condition
  end

  # Register a player's move
  def self.register_move(player, board)
    valid_input?(player, board)
    move = player_move(player)
    updated = board.update(move, player.move_character)

    # Continue asking for valid moves when registration fails.

    if updated
      refresh_board
    else
      puts 'Invalid move'.colorize(:red)
      register_move(player, board)
    end
  end

  # Validate the input provided
  # This method validates that the `player` and `board` arguments received
  # from the user is a valid instance of the `Player` and `Board` classes,
  # respectively.
  def self.valid_input?(player, board)
    raise TypeError, 'Invalid Board object' unless board.is_a?(Board)
    raise TypeError, 'Invalid Player object' unless player.is_a?(Player)
  end

  # Refresh the board after a move has been recorded.
  # The board will have the latest changes so each user sees the current state
  # of the game.
  def self.refresh_board
    system('clear') || system('cls')
    puts 'RubyXO - Your Favorite Tic-Tac-Toe Game'
    puts "========================================\n\n"
    BOARD.display
  end

  # rubocop:disable Metrics/MethodLength

  # Get a player's move
  def self.player_move(player)
    print "#{player.name}[#{player.move_character}]'s " \
            'move (Choose between 1 and 9): '

    begin
      move = Integer(gets.chomp)
    rescue Interrupt
      puts 'Exited'
      exit(1)
    rescue ArgumentError
      puts 'Invalid move'.colorize(:red)
      player_move(player)
    end

    move
  end

  # rubocop:enable Metrics/MethodLength

  # Check if a winner has been determined based on the current board moves.
  # @return `true` if a user is found or a tie has occurred. `false` is
  # returned otherwise.
  def self.user_won?(player)
    status, winner = BOARD.winner_found?

    if status
      puts "The winner is #{player.name} - #{winner}".colorize(:green)
      return true
    end

    if BOARD.tie?
      puts "It's a tie!".colorize(:yellow)
      return true
    end

    false
  end

  # Ask if the user wants to play the again once more.
  # @return `true` if user agrees by specifying 'y', `false` otherwise.
  def self.play_again?
    print 'Would you like to play again? (y/n): '
    option = gets.chomp.downcase

    play_again? unless %w[y n].include?(option) # validate user option

    option == 'y'
  end
end

Utilities.private_methods
