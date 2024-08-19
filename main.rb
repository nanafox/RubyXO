#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/game'

# Entry point for the game
def main
  game = Game.new
  game.start
end

# Run the program
main if __FILE__ == $PROGRAM_NAME
