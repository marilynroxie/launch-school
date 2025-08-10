# Todo
# Adding a class for each move?
# - Not sure if this is a good idea
# - unless I could integrate it with different computer personalities
# Keeping a history of moves
# Computer personalities

# Bonus Features Already Done:
# Keeping score
# Adding Lizard and Spock

require "yaml"

module Message
  MESSAGES = YAML.load_file("oop_rps_with_bonus_features_messages.yaml")

  def messages(message, *args)
    args.empty? ? MESSAGES[message] : MESSAGES[message] % args
  end

  def prompt(key, *args)
    message = messages(key, *args)
    puts("=> #{message}")
  end

  def starred_message(key, *args)
    message = messages(key, *args)
    puts("* #{message} *")
  end
end

module Utilities
  def clear_screen
    system "clear"
  end

  def pause(duration = 0.4)
    sleep duration
  end
end

module Displayable
  include Message
  include Utilities

  def display_welcome
    starred_message("welcome", human.name)
  end

  def display_rules
    messages("rules").each_line do |rule|
      pause(0.4)
      puts rule
    end
  end

  def display_moves(human_move, computer_move)
    puts messages("display", human_move, computer_move)
    pause(0.2)
  end

  def display_winning_move_message(round)
    winner_move, loser_move = round.winner_loser
    unless winner_move
      return puts messages("no_effect", round.human_move, round.computer_move)
    end

    puts(messages("winning_moves_lines")[winner_move.to_s].find do |line|
      line.include?(loser_move.to_s)
    end)
  end

  def display_round_result(round)
    case round.winner
    when :player then puts messages("round_result")["you_won"]
    when :computer then puts messages("round_result")["computer_won"]
    else puts messages("round_result")["tie"]
    end
  end

  def display_scoreboard
    starred_message("separator")
    puts messages("scoreboard", score.player_score,
                  score.computer_score).center(44)
    starred_message("separator")
  end

  def display_grand_winner(winner)
    pause(0.4)
    if winner == :player
      puts messages("grand_winner")["player"]
    else
      puts messages("grand_winner")["computer"]
    end
  end

  def display_grand_scoreboard
    starred_message("separator")
    puts messages("total_grand_winners", grand_score.grand_winners[:player],
                  grand_score.grand_winners[:computer]).center(44)
    starred_message("separator")
  end

  def display_streak
    streaks = grand_score.grand_winners

    if streaks[:player_streak] >= 2
      puts(messages("streak")["player"] % streaks[:player_streak])
    elsif streaks[:computer_streak] >= 2
      puts(messages("streak")["computer"] % streaks[:computer_streak])
    end
  end

  def display_farewell
    starred_message("thank_you", human.name)
  end
end

class Move
  MOVES = {
    "R" => "Rock",
    "P" => "Paper",
    "Sc" => "Scissors",
    "L" => "Lizard",
    "Sp" => "Spock"
  }

  WINNING_MOVES = {
    "Rock" => ["Scissors", "Lizard"],
    "Paper" => ["Rock", "Spock"],
    "Scissors" => ["Paper", "Lizard"],
    "Lizard" => ["Spock", "Paper"],
    "Spock" => ["Scissors", "Rock"]
  }

  attr_reader :value

  def initialize(input)
    @value = convert_move(input)
  end

  def beats?(other_move)
    WINNING_MOVES[value].include?(other_move.value)
  end

  def to_s
    value
  end

  def ==(other)
    value == other.value
  end

  private

  def convert_move(move)
    MOVES.key?(move) ? MOVES[move] : move
  end
end

module GameRules
  ROUNDS_TO_WIN = 3

  def win?(winner_move, loser_move)
    winner_move.beats?(loser_move)
  end

  def valid_move?(input)
    Move::MOVES.key?(input) || Move::MOVES.value?(input)
  end

  def available_moves
    Move::MOVES.values
  end

  def move_shortcuts
    Move::MOVES.keys
  end
end

class Player
  include GameRules

  attr_accessor :move, :name, :score

  def initialize
    @score = 0
    set_name
  end

  protected

  def set_name
    @name = "Player"
  end
end

class Human < Player
  include Displayable

  def set_name
    clear_screen
    loop do
      prompt("enter_name")
      name = gets.chomp.strip.split.map(&:capitalize).join(" ")
      break @name = name unless name.empty?
      prompt("valid_name")
    end
  end

  def choose_move
    loop do
      choice = user_input
      return @move = Move.new(choice) if handle_choice(choice)
    end
  end

  def play_again?
    loop do
      prompt("play_again")
      answer = gets.chomp.strip.downcase

      return true if messages("options_pos").include?(answer)
      return false if messages("options_neg").include?(answer)

      clear_screen
      prompt("invalid_choice")
    end
  end

  private

  def user_input
    prompt("selection")
    gets.chomp.strip.capitalize
  end

  def handle_choice(choice)
    clear_screen
    return display_rules && false if choice == "Rules"
    return true if valid_move?(choice)

    prompt("invalid_choice")
    false
  end
end

class Computer < Player
  def set_name
    @name = ["R2D2", "HAL", "Number5", "Sonny", "Chappie"].sample
  end

  def choose_move
    @move = Move.new(available_moves.sample)
  end
end

class Score
  attr_accessor :player_score, :computer_score

  def initialize
    reset
  end

  def reset
    @player_score = 0
    @computer_score = 0
  end

  def update(winner)
    case winner
    when :player then self.player_score += 1
    when :computer then self.computer_score += 1
    end
  end

  def match_winner
    return :player if player_score == GameRules::ROUNDS_TO_WIN
    return :computer if computer_score == GameRules::ROUNDS_TO_WIN
    nil
  end

  def match_over?
    !match_winner.nil?
  end
end

class GrandScore
  attr_reader :grand_winners

  def initialize
    @grand_winners = {
      player: 0,
      computer: 0,
      player_streak: 0,
      computer_streak: 0
    }
  end

  def update(winner)
    if winner == :player
      @grand_winners[:player] += 1
      @grand_winners[:player_streak] += 1
      @grand_winners[:computer_streak] = 0
    else
      @grand_winners[:computer] += 1
      @grand_winners[:computer_streak] += 1
      @grand_winners[:player_streak] = 0
    end
  end
end

class Round
  include GameRules

  attr_reader :human_move, :computer_move, :winner

  def initialize(human_move, computer_move)
    @human_move = human_move
    @computer_move = computer_move
    @winner = determine_winner
  end

  def winner_loser
    case winner
    when :player
      [human_move, computer_move]
    when :computer
      [computer_move, human_move]
    else
      [nil, nil]
    end
  end

  private

  def determine_winner
    return :player if win?(human_move, computer_move)
    return :computer if win?(computer_move, human_move)
    nil
  end
end

class RPSGame
  include Displayable

  attr_reader :human, :computer, :score, :grand_score

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = Score.new
    @grand_score = GrandScore.new
  end

  def play
    display_welcome

    loop do
      play_match
      break unless human.play_again?
    end

    display_farewell
  end

  private

  def round_results(round)
    display_moves(round.human_move, round.computer_move)
    display_winning_move_message(round)
    display_scoreboard
    display_round_result(round)
  end

  def play_round
    human.choose_move
    computer.choose_move
    round = Round.new(human.move, computer.move)

    score.update(round.winner)
    round_results(round)
  end

  def match_results(winner)
    grand_score.update(winner)
    display_grand_winner(winner)
    display_grand_scoreboard
    display_streak
  end

  def play_match
    score.reset
    until score.match_over?
      play_round
    end

    winner = score.match_winner
    match_results(winner)
  end
end

RPSGame.new.play
