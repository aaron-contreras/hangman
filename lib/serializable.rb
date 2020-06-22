# frozen_string_literal: true

require 'json'

# Serializing functionality to save and restore a game
module Serializable
  EXTENSION = 'json'
  SERIALIZER = JSON
  SAVED_GAMES_DIRECTORY = './saved_games'

  def serialize
    to_serialize = instance_variables.reduce({}) do |object, variable|
      object[variable] = instance_variable_get variable
      object
    end

    SERIALIZER.dump to_serialize
  end

  def deserialize(string)
    object = SERIALIZER.parse string
    object.each do |variable, value|
      instance_variable_set variable, value
    end
  end

  def check_for_saved_games_directory
    Dir.mkdir SAVED_GAMES_DIRECTORY unless Dir.exist? SAVED_GAMES_DIRECTORY
  end

  def saved_games
    Dir.glob "#{SAVED_GAMES_DIRECTORY}/*.json"
  end

  def game_list
    saved_games.each_with_index.reduce({}) do |hash, (file, index)|
      hash[index + 1] = file
      hash
    end
  end

  def filename_to_save
    loop do
      filename = ''
      filename = gets.chomp while filename.empty?
      filename += ".#{EXTENSION}"
      break filename unless File.exist? "./saved_games/#{filename}"

      puts "You've already saved game with this name"
    end
  end

  def valid_load_screen_option
    selected_option = gets.chomp until game_list.key?(selected_option.to_i) || %w[/back /exit].include?(selected_option)

    selected_option
  end

  def game?(selected_option)
    game_list.key? selected_option.to_i
  end

  def save_game_to_file
    filename = filename_to_save
    File.open("./saved_games/#{filename}", 'w') { |file| file.puts serialize }
  end
end
