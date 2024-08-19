# frozen_string_literal: true

# A board class
class Board
  ALLOWED_MOVES = %w[X O].freeze

  # Initialize the board with empty fields.
  def initialize
    @cells = fresh_board
    @used_cells = 0
  end

  # rubocop:disable Metrics/AbcSize

  # Return all possible winning combinations
  def winning_combinations
    [
      [@cells[0], @cells[1], @cells[2]], # Top row
      [@cells[3], @cells[4], @cells[5]], # Middle row
      [@cells[6], @cells[7], @cells[8]], # Bottom row
      [@cells[0], @cells[3], @cells[6]], # Left column
      [@cells[1], @cells[4], @cells[7]], # Middle column
      [@cells[2], @cells[5], @cells[8]], # Right column
      [@cells[0], @cells[4], @cells[8]], # Diagonal from top-left to bottom-right
      [@cells[2], @cells[4], @cells[6]] # Diagonal from top-right to bottom-left
    ]
  end

  # rubocop:enable Metrics/AbcSize

  # Return the string representation of the board.
  def to_s
    " #{@cells[0]} | #{@cells[1]} | #{@cells[2]} \n" \
      "-----------\n" \
      " #{@cells[3]} | #{@cells[4]} | #{@cells[5]} \n" \
      "-----------\n" \
      " #{@cells[6]} | #{@cells[7]} | #{@cells[8]} \n"
  end

  # Display the board.
  def display
    puts self
  end

  # Check if a tie has occurred on the board.
  # @return true if a tie exists, false otherwise.
  def tie?
    full?
  end

  # Update the board with a move.
  # @param position The position to insert the move.
  # @param character The 'X' or 'O' character to put on the board.
  # @return true if the update was successful, false otherwise.
  def update(position, character)
    return false unless valid_move?(position, character)

    @cells[position - 1] = character
    @used_cells += 1
    true
  end

  # Reset the board
  def reset
    @cells = fresh_board
    @used_cells = 0
  end

  # Generate a fresh board
  def fresh_board
    @cells = [' '] * 9
  end

  # Check if a winner has been found so far based on the current board.
  # In the event that a winner is found, `true` and the character that won are
  # returned.
  # For example, if player `X` won, a `[true, 'X']` will be sent as the
  # response.
  def winner_found?
    winning_combinations.each do |combination|
      if combination.all?('X')
        return [true, 'X']
      elsif combination.all?('O')
        return [true, 'O']
      end
    end

    [false, nil] # No winner found
  end

  private

  # Validate that a move on the board is valid before updating
  # @param position The position to insert the move.
  # @param character The 'X' or 'O' character to put on the board.
  def valid_move?(position, character)
    return false if full?

    return false unless position.is_a? Integer

    return false unless ALLOWED_MOVES.include? character

    if @cells[position - 1] != ' '
      false
    else
      position - 1 < @cells.length
    end
  end

  # Check if the board is already full.
  def full?
    @used_cells == @cells.length
  end
end
