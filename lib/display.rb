# frozen_string_literal: true

# Includes all functionality for outputting to the console
module Display
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
end