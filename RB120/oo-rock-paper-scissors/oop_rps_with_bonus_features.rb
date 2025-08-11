# Todo
# Adding a class for each move?
# - Not sure if this is a good idea
# - unless I could integrate it with different computer personalities
# Need to move some move history stuff to YAML
# Computer personalities

# Bonus Features Already Done:
# Keeping score
# Adding Lizard and Spock
# Start of move history

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

  def display_history
    if move_history.current_match_empty? && move_history.total_matches_played == 0
      puts "\nNo moves have been played yet.\n\n"
      return
    end

    display_current_match_history
    display_overall_statistics if move_history.total_matches_played > 0
  end

  def display_current_match_history
    return if move_history.current_match_empty?

    puts "\n#{("=" * 60)}"
    puts "CURRENT MATCH HISTORY".center(60)
    puts "=" * 60

    move_history.current_match_each_with_index do |round_data, index|
      puts "Round #{index + 1}:"
      puts "  #{@game.human.name}: #{round_data[:human_move]}"
      puts "  #{@game.computer.name}: #{round_data[:computer_move]}"
      puts "  Winner: #{format_winner(round_data[:winner])}"
      puts ""
    end

    puts "Current Match - Rounds Played: #{move_history.current_match_size}"
    puts "Current Score - #{@game.human.name}: #{score.player_score}, #{@game.computer.name}: #{score.computer_score}"
    puts "=" * 60
    puts ""
  end

  def display_overall_statistics
    puts "=" * 60
    puts "OVERALL GAME STATISTICS".center(60)
    puts "=" * 60

    puts "Total Matches Played: #{move_history.total_matches_played}"
    puts "#{@game.human.name} Match Wins: #{move_history.overall_wins(:player)}"
    puts "#{@game.computer.name} Match Wins: #{move_history.overall_wins(:computer)}"
    puts ""

    puts "MATCH HISTORY SUMMARY:"
    puts "-" * 30

    move_history.all_matches.each do |match_data|
      winner_name = format_winner(match_data[:winner])
      score = match_data[:final_score]
      puts "Match #{match_data[:match_number]}: #{winner_name} won (#{score[:player]}-#{score[:computer]})"
    end

    puts "=" * 60
    puts ""
  end

  private

  def format_winner(winner)
    case winner
    when :player then @game.human.name
    when :computer then @game.computer.name
    else "Tie"
    end
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
  ROUNDS_TO_WIN = 10

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

  attr_writer :game

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
    return display_history && false if choice == "History" || choice == "H"
    return display_detailed_history && false if choice == "Fullhistory" || choice == "Fh"
    return true if valid_move?(choice)

    prompt("invalid_choice")
    false
  end

  def display_detailed_history
    if move_history.total_matches_played == 0 && move_history.current_match_empty?
      puts "\nNo games have been played yet.\n\n"
      return
    end

    puts "\n#{("=" * 70)}"
    puts "COMPLETE GAME HISTORY".center(70)
    puts "=" * 70

    move_history.all_matches.each do |match_data|
      puts "\nMATCH #{match_data[:match_number]} - Winner: #{format_winner(match_data[:winner])}"
      puts "Final Score: #{@game.human.name} #{match_data[:final_score][:player]} - #{match_data[:final_score][:computer]} #{@game.computer.name}"
      puts "-" * 40

      match_data[:rounds].each_with_index do |round_data, index|
        puts "  Round #{index + 1}: #{@game.human.name}(#{round_data[:human_move]}) vs #{@game.computer.name}(#{round_data[:computer_move]}) - #{format_winner(round_data[:winner])}"
      end
    end

    unless move_history.current_match_empty?
      puts "\nCURRENT MATCH (In Progress)"
      puts "-" * 40
      move_history.current_match_each_with_index do |round_data, index|
        puts "  Round #{index + 1}: #{@game.human.name}(#{round_data[:human_move]}) vs #{@game.computer.name}(#{round_data[:computer_move]}) - #{format_winner(round_data[:winner])}"
      end
    end

    display_overall_statistics if move_history.total_matches_played > 0
  end

  def move_history
    @game&.move_history || []
  end

  def score
    @game&.score
  end

  def computer
    @game&.computer
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

class MoveHistory
  def initialize
    @current_match = []
    @all_matches = []
    @current_match_number = 1
  end

  def add_round(human_move, computer_move, winner)
    round_data = {
      human_move: human_move.to_s,
      computer_move: computer_move.to_s,
      winner: winner,
      match_number: @current_match_number,
    }
    @current_match << round_data
  end

  def finish_match(match_winner)
    return if @current_match.empty?

    match_data = {
      match_number: @current_match_number,
      rounds: @current_match.dup,
      winner: match_winner,
      final_score: calculate_final_score,
    }
    @all_matches << match_data
    @current_match.clear
    @current_match_number += 1
  end

  def current_match_empty?
    @current_match.empty?
  end

  def current_match_each_with_index(&block)
    @current_match.each_with_index(&block)
  end

  def current_match_size
    @current_match.size
  end

  attr_reader :all_matches

  def total_matches_played
    @all_matches.size
  end

  def overall_wins(player_type)
    @all_matches.count { |match| match[:winner] == player_type }
  end

  private

  def calculate_final_score
    player_score = @current_match.count { |round| round[:winner] == :player }
    computer_score = @current_match.count do |round|
      round[:winner] == :computer
    end
    { player: player_score, computer: computer_score }
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

  attr_reader :human, :computer, :score, :grand_score, :move_history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = Score.new
    @grand_score = GrandScore.new
    @move_history = MoveHistory.new

    @human.game = self
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
    move_history.add_round(round.human_move, round.computer_move, round.winner)
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
    move_history.finish_match(winner)
    match_results(winner)
  end
end

RPSGame.new.play
