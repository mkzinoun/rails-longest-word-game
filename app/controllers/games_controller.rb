require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = 10.times.map { alphabet.sample }
    session[:total_score] = 0 unless session[:total_score].present?
  end

  def score
    @score = 0
    @grid = params[:letters].split(' ')
    @in_grid = in_grid?(params[:word].upcase, @grid)
    @valid_word = valid_word?(params[:word])
    @score += params[:word].length
    session[:total_score] += @score
  end

  private

  def in_grid?(word, grid)
    word.each_char do |char|
      if grid.include?(char)
        grid.delete_at(grid.index(char.upcase))
      else
        return false
      end
    end
    return true
  end

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary_serialized = URI.open(url).read
    dictionnary = JSON.parse(dictionary_serialized)
    return dictionnary['found']
  end
end
