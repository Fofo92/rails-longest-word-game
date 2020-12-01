require 'open-uri'
require 'json'

class GamesController < ApplicationController
    def new
      @letters = []
      10.times { @letters << ("A".."Z").to_a.sample }
      return @letters
    end

  def score
    @ref_word = params[:ref_word]
    @answer = params[:result]
    ref_string = @ref_word.gsub(/[[:space:]]/, '')
    # The word can’t be built out of the original grid
    if !letters_in_grid?
      @result = "Sorry, but #{@answer.upcase} can’t be built out of #{ref_string}."
    elsif !find_english_word
      @result = "Sorry but #{@answer.upcase} does not seem to be an English word."
    elsif letters_in_grid? && !find_english_word
      @result = "Sorry but #{@answer.upcase} does not seem to be an English word."
    else letters_in_grid? && !find_english_word
      @result = "Youpi, #{@answer.upcase} is a valid word."
    end
    # The word is valid according to the grid, but is not a valid English word
    # # The word is valid according to the grid and is an English word
  end

  def find_english_word
    api_url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    dictionary = URI.open(api_url).read
    word = JSON.parse(dictionary)
    return word['found']
  end

  def letters_in_grid?
    @answer.chars.sort.all? { |letter| @ref_word.include?(letter.upcase) }
  end
end
