# frozen_string_literal: true

require_relative './displayable.rb'
require_relative './serializable.rb'
require_relative './game_options.rb'

# Game logic for hangman
class Game
  include Displayable
  include Serializable
  include GameOptions

  attr_reader :secret_word, :incorrect_guesses
  attr_accessor :guess, :remaining_letters

  def initialize
    @secret_word = select_secret_word
    @remaining_letters = @secret_word.clone
    @incorrect_guesses = []
    @guess = nil
  end

  def start
    puts start_screen

    option = gets.chomp.downcase until START_SCREEN_OPTIONS.include? option

    clear_screen

    if option == 'n'
      play
    else
      puts load_a_game_screen saved_games
      proceed_with valid_load_screen_option
    end
  end

  private

  def select_secret_word
    dictionary = File.readlines('5desk.txt').map(&:strip)
    dictionary.select { |word| word.length.between? 5, 12 }.sample.downcase
  end

  def word_cracked?
    remaining_letters.length.zero? || secret_word == guess
  end

  def game_is_over?
    incorrect_guesses.length == 7 || word_cracked?
  end

  def no_matches?
    previous_remaining_letters = remaining_letters
    self.remaining_letters = if word_cracked?
                               ' '
                             elsif guess.length == 1
                               remaining_letters.gsub(guess, '')
                             else
                               remaining_letters
                             end

    remaining_letters == previous_remaining_letters
  end

  def update_display
    clear_screen
    puts hanging_man_drawing incorrect_guesses.length
    puts word_status secret_word, remaining_letters, incorrect_guesses
    print guess_prompt unless game_is_over?
  end

  def proceed_with(selected_option)
    return if selected_option == '/exit'

    return Game.new.start if selected_option == '/back'

    game_key = selected_option.to_i
    deserialize File.read(game_list[game_key])
    play
  end

  def update_incorrect_guesses(guess)
    incorrect_guesses << guess if no_matches?
  end

  def save
    print save_game_screen
    save_game_to_file
    puts succesful_save
    sleep(1)
  end

  def correct_guesses
    secret_word.split('') - remaining_letters.split('')
  end

  def already_guessed?(guess)
    correct_guesses.include?(guess) || incorrect_guesses.include?(guess)
  end

  def valid_guess
    guess = loop do
      guess = gets.chomp.strip.downcase

      break guess unless already_guessed?(guess) || guess.empty?
    end
  end

  def run_game_loop
    until game_is_over?
      update_display
      self.guess = valid_guess

      if IN_GAME_OPTIONS.include? guess
        break if guess == '/exit'

        save
        next
      end

      update_incorrect_guesses guess
    end
  end

  def play
    run_game_loop
    return if guess == '/exit'

    update_display
    game_over_message word_cracked?, secret_word

    option = gets.chomp.to_i until END_OF_GAME_OPTIONS.include? option
    Game.new.start if option == 1
  end
end
