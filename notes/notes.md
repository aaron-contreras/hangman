# Notes on "Hangman" project

## Problem solving steps

1. Will the program have a user interface? If so, what will it look like?

  - It will be a **console** interactive program.
  - It has a "Hanging man" that completes itself as the guesser makes a wrong guess.
    - I'm thinking that I can reuse the pegs from my Mastermind game to build a "bolder" gallow making it a bit more attractive. (This is subject to how it looks once I implement it, it could just look terrible)

```
     ______
    |      | 
    O      |
   ╲|╱     |
    |      |
   ╱ ╲     |
           |
           |
           |
           |
       ---------

  _ _ n _ a n      <-- State of word

  g  e  n  handing <-- Wrong guesses

(/save) Save game
```

  - It has the word to be guessed with
    - Blank underscores for unguessed letters.
    - Underscores with the corresponding letter on top of it for correctly guessed letters.
  - A list of **incorrectly guessed** letters AND words(in case there was an attempt to guess the entire word).
  - Every time the player makes a new guess(after every move) the screen is cleared and redrawn to make for a nicer user interface. This should give the appearance of a single screen just being updated instead of things being drawn over and over again on the terminal, making it a bit hard to track where you're at in the game
  - A "**save** button" in one of the corners(don't know which yet) on every player's move/turn.
  - The **"start screen"** should have a "**load** previous game" button.

2. What are the inputs? Where will I be getting them from?
  - The downloaded dictionary as the bank of words to choose for a game.
  - A player's guess (Either a single character or an entire word depending on if they know what the word is already).

3. What are the desired outputs?
  - At the start of the game
    - If a saved game is loaded
      - Reset the state of the game and continue off from it.
  - After each turn
    - Draw the correct hangman figure based on the number of incorrect guesses.
    - The filled in underscores are to be updated with the player's guesses.
    - The bank of incorrect guesses is to be updated if the player's guess is incorrect.
    - If the game is saved
      - Serialize the game and save it into an external file in a "saved_games" directory.
  - If the word is guessed before the "hanged man" is completely filled in, then give the player a "congrats" message.
  - If not then give a "you lose" message

4. How do I go from the listed inputs to the desired outputs?

  _The hangman is "complete" when it is completely drawn (**7 incorrect guesses**)_
  
  - Algorithm
  ```
  - Display the start screen.
  - If the player chooses to load a previous game.
    - Display the list of previously saved games
    - Ask the player which game he'd like to load back.
    - Load the game and continue from its state.

  - Load the dictionary.
  
  - Select a word between 5 and 12 characters long.

  - Assign it to the secret word.

  - Until the hanging man is complete

    - If the player chooses to save the game
      - Ask the player what he'd like to call his game.
      - Serialize the game into a JSON file with the given filename by the user

    - Ask the player for a guess.
  
    - If it's a word
      - Check if the word is the secret word
        - If it is
          - End the game with a winning message
        - If it's not
          - Add the word to the table of incorrect guesses

    - If the guess is a single letter
      - Check if it exists in the remaining list of letters
        - If it is
          - Remove from the remaining letters all the instances of the entered letter.
          - Add them to the blank spaces in the word display
        - If not
          - Add the letter to the incorrect guess table

    - Update the display
      - Update the hangman drawing
      - Update the secret word display
      - Update the incorrect guess display