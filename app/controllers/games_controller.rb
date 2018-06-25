require 'json'
require 'open-uri'

class GamesController < ApplicationController

  ALPHABET = ("A".."Z").to_a

  def new
    @letters = []
    10.times do
      @letters << ALPHABET.sample
    end
    return @letters
  end

  def score
    @word = params[:word]
    @letters = params[:grid].split("")

    if word_in_grid(@word, @letters) == false
      @string = "Sorry, Man. '#{@word}' can't be built out of '#{@letters}'"
    else
      if actual_word(@word) == true
        @string = "Good Job. '#{@word}' is valid according to the grid and is an English word"
      elsif actual_word(@word) == false
        @string =  "Sorry, Man. '#{@word}' is valid according to the grid, but '#{@word}' is not a valid English word"
      end
    end

  end

  def actual_word(word)
    api_response = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{word}").read)
    api_response["found"]
  end

  def word_in_grid(word, grid)
    # count number of appearence of each letter in word
    word_letters = word.upcase.split("")
    word_letters_count = word_letters.map { |letter| word_letters.count(letter) }
    # count number of appearence of the word letters in grid
    grid_letters_count = word_letters.map { |letter| grid.count(letter) }
    # compare both arrays with a loop
    @result = true
    word_letters_count.each_with_index do |count, index|
      if count > grid_letters_count[index]
        @result = false
      end
      @result
    end
  end

end

