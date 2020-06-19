# frozen_string_literal: true

# Game logic for hangman
class Game
  attr_reader :secret_word

  def initialize
    @secret_word = select_secret_word
  end

  private

  def dictionary
    File.readlines('5desk.txt').map(&:strip)
  end

  def select_secret_word
    word_bank = dictionary.filter { |word| word.length.between? 5, 12 }
    word_bank.sample
  end
end
