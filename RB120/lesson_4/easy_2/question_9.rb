class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end

  def play
    "Get out your bingo cards."
  end
end

bingo_game = Bingo.new
p bingo_game.play
