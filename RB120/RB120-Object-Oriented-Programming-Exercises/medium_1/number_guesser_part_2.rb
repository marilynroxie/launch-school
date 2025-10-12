class GuessingGame
  attr_reader :mystery_number, :start_num, :end_num
  attr_accessor :total_guesses, :my_guess

  def initialize(start_num, end_num)
    @start_num = start_num
    @end_num = end_num
    @mystery_number = rand(start_num..end_num)
    @total_guesses = Math.log2(mystery_number).to_i + 1
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
      puts "Enter a number between #{start_num} and #{end_num} "
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

game = GuessingGame.new(501, 1500)
game.play
