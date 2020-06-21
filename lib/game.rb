# frozen_string_literal: true

require 'pry'
require_relative './display.rb'
require_relative './serializable.rb'
# Game logic for hangman
class Game
  include Display
  include Serializable

  attr_reader :secret_word, :incorrect_guesses
  attr_accessor :guess, :remaining_letters

  GAME_MODES = %w[n l].freeze
  SAVED_GAMES = Dir.glob './saved_games/*.json'

  def game_list
    SAVED_GAMES.each_with_index.reduce({}) do |hash, (file, index)|
      hash[index + 1] = file
      hash
    end
  end

  def initialize
    clear_screen
    puts start_screen
    @secret_word = select_secret_word
    @remaining_letters = @secret_word.clone
    @incorrect_guesses = []
    @guess = nil
    start
  end

  def start
    mode = gets.chomp.downcase until GAME_MODES.include? mode
    if mode == 'n'
      play
    else
      clear_screen
      puts load_a_game_screen SAVED_GAMES
      file_number = gets.chomp until game_list.key?(file_number.to_i) || file_number == '/back' || file_number == '/exit'

      if file_number == '/back'
        Game.new
      elsif game_list.key? file_number.to_i
        saved_game = File.read game_list[file_number.to_i]
        deserialize saved_game
        play
      end
    end
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

  def word_status
    "#{hide_secret_word secret_word, remaining_letters}#{incorrect_guess_list incorrect_guesses}"
  end

  def update_display
    clear_screen
    puts hanging_man_drawing incorrect_guesses.length
    puts word_status
    print next_move_prompt
  end

  def play
    update_display
    until no_more_guesses? || word_cracked?
      self.guess = gets.chomp.downcase
      return if guess == '/exit'

      if guess == '/save'
        clear_screen
        puts save_game_screen
        filename = loop do
          filename = ''
          filename = gets.chomp while filename.empty?
          filename += ".#{EXTENSION}"
          break filename unless File.exist? "./saved_games/#{filename}"

          puts "You've already saved game with this name"
        end

        File.open("./saved_games/#{filename}", 'w') { |file| file.puts serialize }
      end

      incorrect_guesses << guess if no_matches?
      update_display
    end

    puts game_over_message word_cracked?
    puts "The word was #{secret_word}"
  end
end
