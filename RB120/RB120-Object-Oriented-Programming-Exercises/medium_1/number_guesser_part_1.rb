class GuessingGame
  attr_reader :mystery_number
  attr_accessor :total_guesses, :my_guess

  def initialize
    @mystery_number = rand(1..100)
    @total_guesses = 7
    @my_guess = nil
  end

  def play
    puts @mystery_number
    loop do
      if total_guesses == 0
        puts " "
        puts "You have no more guesses. You lost!"
        exit
      end
      puts "You have #{total_guesses} guesses remaining"
      puts "Enter a number between 1 and 100 "
      my_guess = gets.chomp.to_i
      if my_guess > mystery_number
        puts "Your guess is too high."
        self.total_guesses -= 1
      elsif my_guess < mystery_number
        puts "Your guess is too low."
        self.total_guesses -= 1
      else
        puts "That's the number!"
        puts " "
        puts "You won!"
        exit
      end
    end
  end
end

game = GuessingGame.new
game.play
