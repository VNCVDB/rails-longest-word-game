class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    # @answer comes straight from the view!
    # @letters comes from view as well, hidden field tag
    @letters = params[:letters]
    @answer = params[:answer]
    if does_api_recognize_word && does_word_match_grid
      @user_result = 'congrats!'
    elsif !does_api_recognize_word && does_word_match_grid
      @user_result = 'not a word'
    else
      @user_result = 'cheater!'
    end
  end

  def does_api_recognize_word
    require 'json'
    require 'open-uri'
    word_api = open("https://wagon-dictionary.herokuapp.com/#{@answer}").read
    api_evaluation = JSON.parse(word_api)
    api_evaluation['found']
  end

  def does_word_match_grid
    answerhash = Hash.new(0)
    gridhash = Hash.new(0)
    result = []
    @letters.chars.each { |i| gridhash[i] += 1 }
    @answer.downcase.split("").each { |i| answerhash[i] += 1 }
    answerhash.keys.each { |i| result << 'grid violation' if answerhash[i] > gridhash[i] }
    !result.include?('grid violation')
  end
end
