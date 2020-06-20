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

  def hangman_drawing(incorrect_guesses)
    drawable_parts = find_drawable_parts incorrect_guesses

    <<~HEREDOC
       #{drawable_parts[:head]}
      #{drawable_parts[:left_arm]}#{drawable_parts[:neck]}#{drawable_parts[:right_arm]}
       #{drawable_parts[:torso]}
      #{drawable_parts[:left_leg]} #{drawable_parts[:right_leg]}
    HEREDOC
  end

  def secret_word_display(secret_word, remaining_letters)
    remaining_letters.split('').each do |remaining_letter|
      secret_word = secret_word.gsub remaining_letter, '_'
    end

    secret_word.split('').join(' ')
  end

  def clear_screen
    # Opting for escape sequences opposed to system 'clear'
    # There is a slight noticeable "erasing" with the latter
    print "\e[2J\e[H"
  end
end
