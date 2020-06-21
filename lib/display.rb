# frozen_string_literal: true

# Includes all functionality for outputting to the console
module Display
  HANGMAN_BODY_PARTS = {
    head: [0, 'O'],
    neck: [1, '|'],
    left_arm: [2, "\u2572"],
    right_arm: [3, "\u2571"],
    torso: [4, '|'],
    left_leg: [5, "\u2571"],
    right_leg: [6, "\u2572"]
  }.freeze

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
  SQUARE = "\e[47m  \e[0m"
  TOP_BAR = SQUARE * (TOP_BAR_WIDTH / SQUARE_WIDTH + 1)
  ROPE = '|'
  POLE = SQUARE
  BOTTOM_BAR = SQUARE * 5

  def start_screen
    <<~HEREDOC
      #{'H A N G M A N'.center 80}
      #{'-------------'.center 80}
      # All possible words are pulled from a dictionary.
      # Words will be between 5 - 12 characters long.
      # You will be able to guess a letter on each move or the entire word if you know what it is.
      # The objective is to figure out the word before the stickman is completely hung. (7 turns)





      # Would you like to start a new game or load a previously saved game and continue from where you left off?
        (N)ew game
        (L)oad game
    HEREDOC
  end

  def show_filenames(files)
    files.map.with_index do |file, index|
      "  (#{index + 1}) #{File.basename(file, '.*').capitalize}"
    end.join("\n")
  end

  def no_saved_games_message
    "You haven't saved any games. Press (b) to go back to the start screen"
  end

  def load_a_game_screen(files)
    return no_saved_games_message if files.empty?

    <<~HEREDOC
      Which game would you like to continue?
      #{show_filenames files}
    HEREDOC
  end

  def find_drawable_parts(incorrect_guesses)
    HANGMAN_BODY_PARTS.each_with_object({}) do |(body_part, content), hash|
      minimum_mistakes = content[0]
      symbol = content[1]

      hash[body_part] = incorrect_guesses > minimum_mistakes ? symbol : ' '
    end
  end

  def stick_figure(incorrect_guesses)
    drawable_parts = find_drawable_parts incorrect_guesses

    <<~HEREDOC.chomp
      #{SCREEN_INDENT} #{drawable_parts[:head]}#{' ' * (TOP_BAR_WIDTH - 2)}#{SQUARE}
      #{SCREEN_INDENT}#{drawable_parts[:left_arm]}#{drawable_parts[:neck]}#{drawable_parts[:right_arm]}#{' ' * (TOP_BAR_WIDTH - 3)}#{SQUARE}
      #{SCREEN_INDENT} #{drawable_parts[:torso]}#{' ' * (TOP_BAR_WIDTH - 2)}#{SQUARE}
      #{SCREEN_INDENT}#{drawable_parts[:left_leg]} #{drawable_parts[:right_leg]}#{' ' * (TOP_BAR_WIDTH - 3)}#{SQUARE}
    HEREDOC
  end


  def hanging_man_drawing(incorrect_guesses)
    <<~HEREDOC
      #{SCREEN_INDENT}#{TOP_BAR}#{SQUARE}#{SQUARE}
      #{SCREEN_INDENT} #{ROPE}#{' ' * (ROPE_TO_POLE_INDENT + 3)}#{POLE}
      #{SCREEN_INDENT} #{ROPE}#{' ' * (ROPE_TO_POLE_INDENT + 2)}#{POLE}
      #{SCREEN_INDENT} #{ROPE}#{' ' * (ROPE_TO_POLE_INDENT + 1)}#{POLE}
      #{SCREEN_INDENT} #{ROPE}#{' ' * ROPE_TO_POLE_INDENT}#{POLE}
      #{stick_figure incorrect_guesses}
      #{SCREEN_INDENT}#{POLE_INDENT}#{POLE}
      #{SCREEN_INDENT}#{POLE_INDENT}#{POLE}
      #{SCREEN_INDENT}#{BOTTOM_BAR_INDENT}#{BOTTOM_BAR}
    HEREDOC
  end

  def secret_word_display(secret_word, remaining_letters)
    remaining_letters.split('').each do |remaining_letter|
      secret_word = secret_word.gsub remaining_letter, '_'
    end

    mystery_word = secret_word.split('').join(' ')
    centered_spacing = SCREEN_WIDTH / 2 - mystery_word.length / 2
    <<~HEREDOC


      #{' ' * centered_spacing}#{secret_word.split('').join(' ')}


    HEREDOC
  end

  def display_incorrect_guesses(incorrect_guesses)
    puts incorrect_guesses.join('  |  ').center(80)
  end

  def next_move_message
    '"/save" to save this game. Go ahead and make a guess: '
  end

  def clear_screen
    # Opting for escape sequences opposed to system 'clear'
    # There is a slight noticeable "erasing" with the latter
    print "\e[2J\e[4;0H"
  end

  def game_over_message(game_won)
    if game_won
      puts 'Good job!'
    else
      puts 'You lost!'
    end
  end
end
