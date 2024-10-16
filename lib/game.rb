# frozen_string_literal: true

require_relative "board"
require_relative "player"
require "colorize"

# rubocop:disable Metrics/ClassLength

# Game class.
class Game
  WINNING_BONUS = 3
  TIE_BONUS = 1

  attr_reader :board

  def welcome_message
    puts "Welcome to RubyXO - Your favorite Tic-Tac-Toe game!".colorize(:green)
    puts "===================================================".colorize(:green)
  end

  # rubocop:disable Metrics/MethodLength

  # Start the game
  def start
    welcome_message

    # @type [Player, Player]
    @player1, @player2 = create_players

    # @type [Board]
    @board = game_board

    [@player1, @player2].each { |player| validate_input_for(player, @board) }

    loop do
      play_game
      score_board
      break unless play_again?

      @board.reset
      refresh_board
    end

    puts "Thank you for playing the game ☺".colorize(:blue)
    exit(0)
  end

  # rubocop:enable Metrics/MethodLength

  # Print the score board.
  def score_board
    puts "\n#{@player1}\n#{@player2}\n\n"
  end

  # Creates players for the game.
  def create_players
    puts "\nCreate your players\n".colorize(:magenta)
    puts

    characters = %w[X O]
    characters.each_with_index.map do |character, index|
      create_player(character, index)
    end
  rescue Interrupt, NoMethodError
    handle_exit
  end

  # Register a player's move
  def register_move(player)
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
    unless board.is_a?(Board)
      return { valid: false, message: "Invalid Board object" }
    end

    unless player.is_a?(Player)
      return { valid: false, message: "Invalid Player object" }
    end

    { valid: true }
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
  # @return [Board] The board for the game.
  def game_board
    board = Board.new
    board.display
    board
  end

  # rubocop:disable Metrics/MethodLength

  # Check if a user has won the game.
  # @param player [Player] The player to check if they have won the game.
  # @param board [Board] The board to check if the player has won.
  # @return `true` if the player has won, `false` otherwise.
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

  private

    def validate_input_for(player, board)
      valid_input = valid_input?(player, board)
      return if valid_input[:valid]

      puts valid_input[:message].colorize(:red)
      exit(1)
    end

    def create_player(character, index)
      print "Enter the name for Player #{index + 1} " \
        "(default: Player##{index + 1}): "
      name = gets.chomp.strip
      name = "Player##{index + 1}" if name.empty?
      Player.new(name, character)
    end

    def handle_exit
      puts "Exited"
      exit
    end
  # rubocop:enable Metrics/MethodLength
end

# rubocop:enable Metrics/ClassLength
