# frozen_string_literal: true

# Formatting and styling for text output
module Styleable
  COLORS = {
    fg: {
      black: 30,
      red: 31,
      green: 32,
      yellow: 33,
      blue: 34,
      magenta: 35,
      cyan: 36,
      white: 37,
    },
    bg: {
      black: 40,
      red: 41,
      green: 42,
      yellow: 43,
      blue: 44,
      magenta: 45,
      cyan: 46,
      white: 47,
    }
  }.freeze

  BOLD = 1  

  def colorize(string, color)
    "\e[#{color}m#{string}\e[0m"
  end

  def stylize(string, style)
    "\e[#{style}m#{string}\e[0m"
  end

  HANGMAN_BODY_PARTS = {
    head: [0, 'O'],
    neck: [1, '|'],
    left_arm: [2, "\u2572"],
    right_arm: [3, "\u2571"],
    torso: [4, '|'],
    left_leg: [5, "\u2571"],
    right_leg: [6, "\u2572"]
  }.freeze

  CHARACTER_NAME = 'Steve'

  # Use an even numbered offset for the top bar
  SCREEN_WIDTH = 80
  LEFT_OFFSET = 25
  TOP_BAR_WIDTH = 22
  SQUARE_WIDTH = 2
  BOTTOM_BAR_OFFSET = TOP_BAR_WIDTH - 2 * SQUARE_WIDTH
  ROPE_TO_POLE_INDENT = TOP_BAR_WIDTH - 1

  SCREEN_INDENT = ' ' * LEFT_OFFSET
  BOTTOM_BAR_INDENT = ' ' * BOTTOM_BAR_OFFSET
  POLE_INDENT = ' ' * TOP_BAR_WIDTH
  HEAD_AND_TORSO_INDENT = ' ' * (TOP_BAR_WIDTH - 2)
  EXTREMITIES_INDENT = ' ' * (TOP_BAR_WIDTH - 3)

  SQUARE = "\e[47m  \e[0m"
  BULLET = "\u27a0"
  TOP_BAR = SQUARE * (TOP_BAR_WIDTH / SQUARE_WIDTH + 1)
  ROPE = '|'
  POLE = SQUARE
  BOTTOM_BAR = SQUARE * 5
end