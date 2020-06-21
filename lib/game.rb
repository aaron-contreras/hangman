# frozen_string_literal: true

require 'pry'
require_relative './display.rb'
# Game logic for hangman
class Game
  include Display

  attr_reader :secret_word, :incorrect_guesses
  attr_accessor :guess, :remaining_letters

  def initialize
    puts start_screen
    @secret_word = 'desirability' # select_secret_word
    @remaining_letters = @secret_word.clone
    @incorrect_guesses = []
    @guess = nil
    start
  end

  def start
    play
  end

  private

  def dictionary
    File.readlines('5desk.txt').map(&:strip)
  end

  def select_secret_word
    word_bank = dictionary.filter { |word| word.length.between? 5, 12 }
    word_bank.sample.downcase
  end

  def word_cracked?
    remaining_letters.length.zero? || secret_word == guess
  end

  def no_more_guesses?
    incorrect_guesses.length == 7
  end

  def no_matches?
    previous_remaining_letters = remaining_letters
    self.remaining_letters = remaining_letters.gsub guess, ''
    remaining_letters == previous_remaining_letters
  end

  def update_display
    clear_screen
    puts gallow incorrect_guesses.length
    puts secret_word_display secret_word, remaining_letters
    puts "Incorrect guesses #{incorrect_guesses}"
    puts "Remaining letters #{remaining_letters}"
  end

  def play
    update_display
    until no_more_guesses? || word_cracked?
      self.guess = gets.chomp.downcase
      incorrect_guesses << guess if no_matches?
      update_display
    end

    puts game_over_message word_cracked?
    puts "The word was #{secret_word}"
  end
end
