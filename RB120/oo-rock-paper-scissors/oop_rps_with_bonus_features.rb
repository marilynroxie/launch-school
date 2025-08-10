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
  include Utilities
  include Message

  def welcome_player
    starred_message("welcome", human.name)
  end

  def display_rules
    messages("rules").each_line do |rule|
      pause(0.4)
      puts rule
    end
  end

  def display_moves
    puts messages("display", @human.move, @computer.move)
    pause(0.2)
  end

  def display_winning_move_message
    winner_move, loser_move = determine_winner_loser
    unless winner_move
      return puts messages("no_effect", @human.move,
                           @computer.move)
    end

    winning_line = messages("winning_moves_lines")[winner_move.to_s].find do |line|
      line.include?(loser_move.to_s)
    end
    puts winning_line
  end

  def display_round_result
    if win?(@human.move, @computer.move)
      puts messages("round_result")["you_won"]
    elsif win?(@computer.move, @human.move)
      puts messages("round_result")["computer_won"]
    else
      puts messages("round_result")["tie"]
    end
  end

  def display_scoreboard
    starred_message("separator")
    puts messages("scoreboard", @player_score, @computer_score).center(44)
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
    puts messages("total_grand_winners", @grand_winners[:player],
                  @grand_winners[:computer]).center(44)
    starred_message("separator")
  end

  def display_streak
    if @grand_winners[:player_streak] >= 2
      puts(messages("streak")["player"] % @grand_winners[:player_streak])
    elsif @grand_winners[:computer_streak] >= 2
      puts(messages("streak")["computer"] % @grand_winners[:computer_streak])
    end
  end

  def farewell_player
    starred_message("thank_you", @human.name)
  end
end

class Move
  MOVES = {
    "R" => "Rock",
    "P" => "Paper",
    "Sc" => "Scissors",
    "L" => "Lizard",
    "Sp" => "Spock",
  }

  WINNING_MOVES = {
    "Rock" => ["Scissors", "Lizard"],
    "Paper" => ["Rock", "Spock"],
    "Scissors" => ["Paper", "Lizard"],
    "Lizard" => ["Spock", "Paper"],
    "Spock" => ["Scissors", "Rock"],
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
  include Displayable
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
  COMPUTER_NAMES = ["R2D2", "HAL", "Number5", "Sonny", "Chappie"]

  def set_name
    @name = COMPUTER_NAMES.sample
  end

  def choose_move
    @move = Move.new(available_moves.sample)
  end
end

class Score
  include Displayable

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
  include Displayable

  def initialize
    @grand_winners = {
      player: 0,
      computer: 0,
      player_streak: 0,
      computer_streak: 0,
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

class RPSGame
  include Message
  include Displayable
  include GameRules

  attr_reader :human, :computer, :score, :grand_score

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = Score.new
    @grand_score = GrandScore.new
  end

  def play
    welcome_player

    loop do
      play_match
      handle_match_end
      break unless play_again?
    end

    farewell_player
  end

  private

  def play_match
    score.reset

    until score.match_over?
      play_round
    end
  end

  def play_round
    human.choose_move
    computer.choose_move

    display_moves
    display_winning_move_message
    update_score
    score.display_scoreboard
    display_round_result
  end

  def determine_winner_loser
    if win?(human.move, computer.move)
      [human.move, computer.move]
    elsif win?(computer.move, human.move)
      [computer.move, human.move]
    else
      [nil, nil]
    end
  end

  def update_score
    if win?(human.move, computer.move)
      score.update(:player)
    elsif win?(computer.move, human.move)
      score.update(:computer)
    end
  end

  def handle_match_end
    winner = score.match_winner
    grand_score.update(winner)
    grand_score.display_grand_winner(winner)
    grand_score.display_grand_scoreboard
    grand_score.display_streak
  end

  def play_again?
    loop do
      answer = play_again_input
      result = play_again_answer(answer)
      return result unless result.nil?
    end
  end

  def play_again_input
    prompt("play_again")
    gets.chomp.strip.downcase
  end

  def play_again_answer(answer)
    if messages("options_pos").include?(answer)
      clear_screen
      true
    elsif messages("options_neg").include?(answer)
      false
    else
      clear_screen
      prompt("invalid_choice")
      nil
    end
  end
end

RPSGame.new.play
