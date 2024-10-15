# frozen_string_literal: true

require_relative "board"
require_relative "player"
require "colorize"

# rubocop:disable Metrics/ClassLength

# Game class.
class Game
  WINNING_BONUS = 3
  TIE_BONUS = 1

  def initialize
    puts "Welcome to RubyXO - Your favorite Tic-Tac-Toe game!".colorize(:green)
    puts "===================================================".colorize(:green)

    begin
      puts "\nCreate your players\n".colorize(:magenta)
      @player1, @player2 = create_players
      puts
    rescue Interrupt, NoMethodError
      puts "Exited"
      exit
    end
  end

  # Start the game
  def start
    @board = game_board

    loop do
      play_game

      score_board
      break unless play_again?

      # Reset the board for a new game
      @board.reset and refresh_board
    end

    puts "Thank you for playing the game ☺".colorize(:blue)
    exit(0)
  end

  private

    # Print the score board.
    def score_board
      puts "\n#{@player1}\n#{@player2}\n\n"
    end

    # Register a player's move
    def register_move(player)
      puts
      valid_input?(player, @board)
      move = player_move(player)
      updated, err_msg = @board.update(move, player.move_character)

      # Continue asking for valid moves when registration fails.
      if updated
        refresh_board
      else
        puts "Invalid move: #{err_msg}".colorize(:red)
        register_move(player)
      end
    end

    # Validate the input provided
    # This method validates that the `player` and `board` arguments received
    # from the user is a valid instance of the `Player` and `Board` classes,
    # respectively.
    def valid_input?(player, board)
      raise TypeError, "Invalid Board object" unless board.is_a?(Board)
      raise TypeError, "Invalid Player object" unless player.is_a?(Player)
    end

    # Logic to play the game
    def play_game
      loop do
        register_move(@player1)
        break if user_won?(@player1, @board)

        register_move(@player2)
        break if user_won?(@player2, @board)
      end
    end

    # Ask if the user wants to play the again once more.
    # @return `true` if user agrees by specifying 'y', `false` otherwise.
    def play_again?
      print "Would you like to play again? (y/n): "
      begin
        option = gets.chomp.downcase
      rescue Interrupt
        puts "Exited"
        exit
      end

      play_again? unless %w[y n].include?(option) # validate user option

      option == "y"
    end

    def create_players
      characters = %w[X O]
      players = []

      characters.each_with_index do |character, index|
        print "Enter the name for Player #{index + 1} " \
          "(default: Player##{index + 1}): "
        name = gets.chomp
        name = "Player##{index + 1}" if name.strip.empty?
        players << Player.new(name, character)
      end

      players
    end

    # Refresh the board after a move has been recorded.
    # The board will have the latest changes so each user sees the current state
    # of the game.
    def refresh_board
      system("clear") || system("cls")
      puts "RubyXO - Your Favorite Tic-Tac-Toe Game".colorize(:green)
      puts "========================================\n\n".colorize(:green)
      @board.display
    end

    # Generate the board for the game.
    def game_board
      board = Board.new
      board.display
      board
    end

    # rubocop:disable Metrics/MethodLength

    def user_won?(player, board)
      status, winner = board.winner_found?

      if status
        record_game(outcome: "win", player:)
        puts "\nThe winner is #{player.name} - #{winner}".colorize(:green)
        return true
      end

      if board.tie?
        record_game(outcome: "tie", player:)
        puts "\nIt's a tie!".colorize(:yellow)
        return true
      end

      false
    end

    def record_game(outcome:, player:)
      if outcome == "win"
        winner, loser = if @player1 == player
                          [@player1,
                           @player2]
                        else
                          [@player2, @player1]
                        end
        winner.score += WINNING_BONUS
        winner.games_won += 1
        loser.games_lost += 1
      elsif outcome == "tie"
        [@player1, @player2].each do |p|
          p.score += TIE_BONUS
          p.ties += 1
        end
      else
        raise "Invalid input for outcome: #{outcome.inspect}." \
          "Expected 'win' or 'tie'."
      end
    end

    # Get a player's move
    def player_move(player)
      print "#{player.name}[#{player.move_character}]'s " \
        "move (Choose between 1 and 9): "

      begin
        move = Integer(gets.chomp)
      rescue Interrupt, NoMethodError
        puts "Exited"
        exit
      rescue ArgumentError
        puts "Expected a number between 1 and 9".colorize(:red)
        move = player_move(player)
      end

      move
    end

  # rubocop:enable Metrics/MethodLength
end

# rubocop:enable Metrics/ClassLength
