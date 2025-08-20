# Todo
# Further separation of concerns for handle_choice and special_command
# Separate player character from user interface regarding Human

# Done
# Message and Utilities as container modules
# clear_screen as class method
# format_winner moved to WinnerFormattable module

require "yaml"

module Message
  MESSAGES = YAML.load_file("oop_rps_with_bonus_features_messages.yaml")

  def self.[](key, *args)
    args.empty? ? MESSAGES[key] : MESSAGES[key] % args
  end

  def self.prompt(key, *args)
    message = self[key, *args]
    puts("=> #{message}")
  end

  def self.starred_message(key, *args)
    message = self[key, *args]
    puts("* #{message} *")
  end
end

module Utilities
  def self.clear_screen
    system "clear"
  end

  def self.pause(duration = 0.4)
    sleep duration
  end
end

module WinnerFormattable
  private

  def format_winner(winner)
    case winner
    when :player then @game.human.name
    when :computer then @game.computer.name
    else Message["match"]["winner_names"]["tie"]
    end
  end
end

module CurrentMatchDisplay
  include WinnerFormattable

  def display_current_match_history
    return if move_hist.current_match_empty?

    puts Message["hist"]["headers"]["current_match"]
    display_current_match_rounds
    display_current_match_summary
  end

  def display_current_match_rounds
    move_hist.current_match_each_with_index do |round_data, index|
      display_single_round(round_data, index)
    end
  end

  private

  def display_single_round(round_data, index)
    display_round_number(index + 1)
    display_player_moves(round_data)
    display_round_winner(round_data[:winner])
  end

  def display_round_number(round_num)
    puts Message["hist"]["round_display"] % round_num
  end

  def display_player_moves(round_data)
    display_player_move(@game.human.name, round_data[:human_move])
    display_player_move(@game.computer.name, round_data[:computer_move])
  end

  def display_player_move(player_name, move)
    puts format(Message["hist"]["player_move"], player_name, move)
  end

  def display_round_winner(winner)
    puts Message["hist"]["win_display"] % format_winner(winner)
  end

  def display_current_match_summary
    puts Message["hist"]["current_match_played"] % move_hist.current_match_size
    puts format(Message["hist"]["current_score"], @game.human.name,
                score.player_score, @game.computer.name, score.computer_score)
  end
end

module OverallStatsDisplay
  include WinnerFormattable

  def display_overall_statistics
    display_overall_stats_header
    display_match_statistics
    display_match_history_summary
  end

  private

  def display_overall_stats_header
    puts Message["hist"]["headers"]["overall_stats"].center(60)
    puts Message["hist"]["total_matches"] % move_hist.total_matches_played
  end

  def display_match_statistics
    puts format(Message["hist"]["match_wins"], @game.human.name,
                move_hist.overall_wins(:player))
    puts format(Message["hist"]["match_wins"], @game.computer.name,
                move_hist.overall_wins(:computer))
  end

  def display_match_history_summary
    puts Message["hist"]["headers"]["match_history_summary"]

    move_hist.all_matches.each do |match_data|
      display_single_match_summary(match_data)
    end

    puts Message["separator"]
  end

  def display_single_match_summary(match_data)
    winner_name = format_winner(match_data[:winner])
    score = match_data[:final_score]
    puts format(Message["hist"]["match_summary"],
                match_data[:match_number], winner_name,
                score[:player], score[:computer])
  end
end

module DetailedHistoryDisplay
  include WinnerFormattable

  def display_detailed_history
    puts Message["hist"]["no_games"] if no_games_played?

    puts Message["hist"]["headers"]["complete_history"]
    display_all_completed_matches
    display_current_match_if_in_progress
    display_overall_statistics if move_hist.total_matches_played > 0
  end

  private

  def no_games_played?
    move_hist.total_matches_played == 0 && move_hist.current_match_empty?
  end

  def display_all_completed_matches
    move_hist.all_matches.each do |match_data|
      display_match_header(match_data)
      display_match_rounds(match_data[:rounds])
    end
  end

  def display_match_header(match_data)
    display_match_title(match_data)
    display_final_score(match_data[:final_score])
  end

  def display_match_title(match_data)
    winner = format_winner(match_data[:winner])
    puts format(Message["match"]["header"], match_data[:match_number], winner)
  end

  def display_final_score(final_score)
    puts format(Message["hist"]["final_score_display"],
                @game.human.name, final_score[:player],
                final_score[:computer], @game.computer.name)
  end

  def display_match_rounds(rounds)
    rounds.each_with_index do |round_data, index|
      puts format(Message["hist"]["round_vs_display"],
                  index + 1, @game.human.name, round_data[:human_move],
                  @game.computer.name, round_data[:computer_move],
                  format_winner(round_data[:winner]))
    end
  end

  def display_current_match_if_in_progress
    return if move_hist.current_match_empty?

    puts Message["hist"]["headers"]["current_match_in_progress"]
    move_hist.current_match.each_with_index do |round_data, index|
      display_round(round_data, index)
    end
  end

  def display_round(round_data, index)
    puts format(Message["hist"]["round_vs_display"],
                index + 1, @game.human.name, round_data[:human_move],
                @game.computer.name, round_data[:computer_move],
                format_winner(round_data[:winner]))
  end
end

module DisplayableHistory
  include CurrentMatchDisplay
  include OverallStatsDisplay
  include DetailedHistoryDisplay

  def display_history
    if move_hist.current_match_empty? && move_hist.total_matches_played == 0
      puts Message["hist"]["no_moves"]
      return
    end

    display_current_match_history
    display_overall_statistics if move_hist.total_matches_played > 0
  end
end

module Displayable
  include DisplayableHistory

  def display_welcome
    Message.starred_message("welcome", human.name)
  end

  def display_rules
    Message["rules"].each_line do |rule|
      Utilities.pause(0.4)
      puts rule
    end
  end

  def display_moves(human_move, computer_move)
    puts Message["display", human_move, computer.name, computer_move]
    Utilities.pause(0.2)
  end

  def display_winning_move_message(round)
    winner_move, loser_move = round.winner_loser
    unless winner_move
      return puts Message["no_effect", round.human_move, round.computer_move]
    end

    puts(Message["winning_moves_lines"][winner_move.to_s].find do |line|
      line.include?(loser_move.to_s)
    end)
  end

  def display_round_result(round)
    case round.winner
    when :player
      puts Message["round_result"]["you_won"]
    when :computer
      puts Message["round_result"]["computer_won"] % computer.name
    else puts Message["round_result"]["tie"]
    end
  end

  def display_scoreboard
    Message.starred_message("separator")
    puts Message["scoreboard", human.name, score.player_score, computer.name,
                 score.computer_score].center(44)
    Message.starred_message("separator")
  end

  def display_grand_winner(winner)
    Utilities.pause(0.4)
    if winner == :player
      puts Message["grand_winner"]["player"]
    else
      puts Message["grand_winner"]["computer"] % computer.name
    end
  end

  def display_grand_scoreboard
    Message.starred_message("separator")
    puts Message["total_grand_winners", human.name,
                 grand_score.grand_winners[:player],
                 computer.name,
                 grand_score.grand_winners[:computer]].center(44)
    Message.starred_message("separator")
  end

  def display_streak
    streaks = grand_score.grand_winners

    if streaks[:player_streak] >= 2
      puts(Message["streak"]["player"] % streaks[:player_streak])
    elsif streaks[:computer_streak] >= 2
      puts(format(Message["streak"]["computer"], computer.name,
                  streaks[:computer_streak]))
    end
  end

  def display_farewell
    Message.starred_message("thank_you", human.name)
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
    set_name
  end

  private

  def set_name
    @name = "Player"
  end
end

class Human < Player
  include Displayable

  attr_writer :game

  def choose_move
    loop do
      choice = user_input
      return @move = Move.new(choice) if handle_choice?(choice)
    end
  end

  def play_again?
    loop do
      Message.prompt("play_again")
      answer = gets.chomp.strip.downcase

      return true if Message["options_pos"].include?(answer)
      return false if Message["options_neg"].include?(answer)

      Utilities.clear_screen
      Message.prompt("invalid_choice")
    end
  end

  private

  def set_name
    Utilities.clear_screen
    loop do
      Message.prompt("enter_name")
      name = gets.chomp.strip.split.map(&:capitalize).join(" ")
      break @name = name unless name.empty?
      Message.prompt("valid_name")
    end
  end

  def user_input
    Message.prompt("selection")
    gets.chomp.strip.capitalize
  end

  def handle_choice?(choice)
    Utilities.clear_screen

    if special_command?(choice)
      execute_special_command(choice)
      return false
    end

    return true if valid_move?(choice)

    Message.prompt("invalid_choice")
    false
  end

  def move_hist
    @game.move_hist
  end

  def score
    @game.score
  end

  def computer
    @game.computer
  end

  def special_command?(choice)
    commands = Message["special_commands"]
    [commands["rules"], *commands["history"],
     *commands["full_history"]].include?(choice)
  end

  def execute_special_command(choice)
    commands = Message["special_commands"]
    case choice
    when commands["rules"] then display_rules
    when *commands["history"] then display_history
    when *commands["full_history"] then display_detailed_history
    end
  end
end

class Computer < Player
  def choose_move
    @move = Move.new(available_moves.sample)
  end

  private

  def set_name
    @name = ["R2D2", "HAL", "Number5", "Sonny", "Chappie"].sample
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

  def update(round)
    winner = round.winner

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

class MoveHistory
  attr_reader :current_match, :all_matches

  def initialize
    @current_match = []
    @all_matches = []
    @current_match_number = 1
  end

  def add_round(round)
    round_data = {
      human_move: round.human_move.to_s,
      computer_move: round.computer_move.to_s,
      winner: round.winner,
      match_number: @current_match_number
    }
    @current_match << round_data
  end

  def finish_match(match_winner)
    return if @current_match.empty?

    match_data = {
      match_number: @current_match_number,
      rounds: @current_match.dup,
      winner: match_winner,
      final_score: calculate_final_score
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

  attr_reader :human, :computer, :score, :grand_score, :move_hist

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = Score.new
    @grand_score = GrandScore.new
    @move_hist = MoveHistory.new

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

    score.update(round)
    move_hist.add_round(round)
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
    move_hist.finish_match(winner)
    match_results(winner)
  end
end

RPSGame.new.play
