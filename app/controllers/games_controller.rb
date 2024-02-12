require "json"
require "open-uri"
require "set"

class GamesController < ApplicationController
  def new
    @letters = get_letters()
  end

  def score
    @answer = params[:answer]
    @grid = params[:grid]
    if check_dic(@answer)
      if check_valid(@answer, @grid)
        @message = "Congratulations! #{@answer} is a valid English word!"
      else
        @message = "Sorry but #{@answer} can't be built out of #{@grid}"
      end
    else
      @message = "Sorry but #{@answer} does not seem to be a valid English word..."
    end
  end
end

def get_letters()
  letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
  return letters.sample(10)
end

def check_dic(word)
  response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read
  repos = JSON.parse(response)
  return repos["found"]
end

def check_valid(word, grid)
  grid = grid.split
  word.split("").each do |letter|
    s1 = Set[letter]
    s2 = grid.to_set
    if s1.subset?s2
      grid.delete_at(grid.index(letter))
    else
      return false
    end
  end
  return true
end
