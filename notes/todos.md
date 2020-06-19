# Todo list

Todo list pulled from the algorithm in the problem solving steps. Helps keep track of what's been done and what's missing.

  - [ ] Display the start screen.

  - [ ] If the player chooses to load a previous game.
    - [ ] Display the list of previously saved games
    - [ ] Ask the player which game he'd like to load back.
    - [ ] Load the game and continue from its state.

  - [x] Load the dictionary.
  
  - [x] Select a word between 5 and 12 characters long.

  - [x] Assign it to the secret word.

  - [ ] Until the hanging man is complete

    - If the player chooses to save the game
      - [ ] Ask the player what he'd like to call his game.
      - [ ] Serialize the game into a JSON file with the given filename by the user
  
    - [x] Ask the player for a guess
    - [x] If it's a word
      - [x] Check if the word is the secret word
        - If it is
          - [x] End the game with a winning message
        - If it's not
          - [x] Add the word to the table of incorrect guesses

    - [x] If the guess is a single letter
      - [x] Check if it exists in the remaining list of letters
        - If it is
          - [x] Remove from the remaining letters all the instances of the entered letter.
          - [x] Add them to the blank spaces in the word display
        - If not
          - [x] Add the letter to the incorrect guess table
    - [ ] Update the display
      - [ ] Update the hangman drawing
      - [ ] Update the secret word display
      - [ ] Update the incorrect guess display