# frozen_string_literal: true

require 'pry'
# Game logic for hangman
class Game
  attr_reader :secret_word, :incorrect_guesses
  attr_accessor :guess, :remaining_letters

  def initialize
    @secret_word = select_secret_word
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
    remaining_letters.length.zero? || guess == secret_word
  end

  def no_more_guesses?
    incorrect_guesses.length == 7
  end

  def found_matches?
    remaining_letters.gsub! guess, ''
  end

  def play
    puts secret_word

    until no_more_guesses?
      self.guess = gets.chomp.downcase
      break if word_cracked?

      incorrect_guesses << guess unless found_matches?
      puts "Incorrect guesses #{incorrect_guesses}"
      puts "Remaining letters #{remaining_letters}"
    end

    if word_cracked?
      puts "Good job!"
    else
      puts "You lost!"
    end
  end
end
