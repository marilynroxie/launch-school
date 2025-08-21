require "yaml"

module Message
  MESSAGES = YAML.load_file("oop_ttt_bonus_features.yaml")

  def self.[](key, *args)
    args.empty? ? MESSAGES[key] : MESSAGES[key] % args
  end

  def self.prompt(key, *args)
    message = self[key, *args]
    puts("=> #{message}")
  end

  def self.starred(key, *args)
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

module GameRules
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]] # diagonals
  ROUNDS_TO_WIN = 5
end

module CurrentMatchDisplay
  def display_game_state(score, board)
    Utilities.clear_screen
    score.display
    puts format(Message["markers"], @player.marker, @computer.name,
                @computer.marker)
    board.display
    puts ""
  end

  def display_round_result(winner)
    Utilities.pause(0.2)
    case winner
    when "Player"
      puts Message["round_result"]["you_won"]
    when "Computer"
      puts format(Message["round_result"]["computer_won"], @computer.name)
    else
      puts Message["round_result"]["draw"]
    end
  end

  def display_match_winner(score)
    if score.player_wins == GameRules::ROUNDS_TO_WIN
      puts Message["grand_winner"]["player"]
    elsif score.computer_wins == GameRules::ROUNDS_TO_WIN
      puts format(Message["grand_winner"]["computer"], @computer.name)
    end
  end

  def display_square_prompt(board)
    puts "=> #{format(Message['choose_square'],
                      squares: board.available_squares_formatted)}"
  end
end

module Displayable
  def display_welcome(name)
    Message.starred("welcome", name)
  end

  def display_rules_prompt
    Message.prompt("rules_question")
    input = gets.chomp
    Utilities.clear_screen
    return unless input.downcase == "rules"

    Message["rules"].each_line do |rule|
      Utilities.pause(0.2)
      puts rule
    end

    gets
    Utilities.clear_screen
  end

  def display_starting_player_options
    Message["who_goes_first"].each_line do |turn|
      Utilities.pause(0.2)
      puts turn
    end
  end

  def display_invalid_choice_with_pause
    puts Message["invalid_choice"]
    Utilities.pause(0.5)
  end

  def display_invalid_choice_with_clear
    display_invalid_choice_with_pause
    Utilities.clear_screen
  end

  def display_invalid_play_again_choice
    Utilities.clear_screen
    puts Message["invalid_choice"]
  end

  def display_total_scores(grand_winners)
    Message.starred("separator")
    puts format(Message["total_grand_winners"], @player.marker,
                grand_winners[:player], @computer.name, @computer.marker,
                grand_winners[:computer])
    Message.starred("separator")
  end

  def display_streak(grand_winners)
    if grand_winners[:player_streak] >= 2
      puts format(Message["streak"]["player"], grand_winners[:player_streak])
    elsif grand_winners[:computer_streak] >= 2
      puts format(Message["streak"]["computer"], @computer.name,
                  grand_winners[:computer_streak])
    end
  end

  def display_grand_results(score, grand_winners)
    Utilities.pause
    Utilities.clear_screen
    score.display
    display_match_winner(score)
    display_total_scores(grand_winners)
    display_streak(grand_winners)
  end

  def display_board_row(squares, row)
    puts Message["column_line"]
    puts "  #{squares[(row * 3) + 1]}  |  " \
         "#{squares[(row * 3) + 2]}  |  " \
         "#{squares[(row * 3) + 3]}"
    puts Message["column_line"]
  end

  def display_board_line(squares)
    3.times do |row|
      display_board_row(squares, row)
      puts Message["separator"] unless row == 2
    end
  end

  def display_thank_you(name)
    Message.starred("thank_you", name)
  end
end

class Player
  attr_reader :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Human < Player
  include CurrentMatchDisplay
  include Displayable

  def make_move(board)
    square = get_valid_square(board)
    board.place_marker(square, @marker)
  end

  private

  def get_valid_square(board)
    loop do
      display_square_prompt(board)
      input = gets.chomp
      return input.to_i if board.valid_move?(input.to_i)
      display_invalid_choice_with_pause
    end
  end
end

class Computer < Player
  include GameRules

  def initialize(marker, player_marker)
    name = set_name
    super(name, marker)
    @player_marker = player_marker
  end

  def make_move(board)
    square = find_best_move(board)
    board.place_marker(square, @marker) if square
  end

  private

  def set_name
    ["R2D2", "HAL", "Number5", "Sonny", "Chappie"].sample
  end

  def find_best_move(board)
    offensive_square(board) ||
      defensive_square(board) ||
      center_square(board) ||
      random_square(board)
  end

  def offensive_square(board)
    find_at_risk_square(board, @marker)
  end

  def defensive_square(board)
    find_at_risk_square(board, @player_marker)
  end

  def find_at_risk_square(board, marker)
    WINNING_LINES.each do |line|
      if board.line_has_two_markers?(line, marker)
        empty_square = board.find_empty_square_in_line(line)
        return empty_square if empty_square
      end
    end
    nil
  end

  def center_square(board)
    5 if board.square_empty?(5)
  end

  def random_square(board)
    board.available_squares.sample
  end
end

class Board
  include Displayable
  include GameRules

  def initialize(player_marker, computer_marker)
    @squares = {}
    (1..9).each { |num| @squares[num] = num.to_s }
    @player_marker = player_marker
    @computer_marker = computer_marker
  end

  def display
    display_board_line(@squares)
  end

  def place_marker(square, marker)
    @squares[square] = marker
  end

  def square_empty?(square)
    @squares[square] == square.to_s
  end

  def available_squares
    @squares.keys.select { |num| square_empty?(num) }
  end

  def available_squares_formatted
    joinor(available_squares)
  end

  def valid_move?(square)
    available_squares.include?(square)
  end

  def game_over?
    winner || board_full?
  end

  def winner
    WINNING_LINES.each do |line|
      if line_complete?(line, @player_marker)
        return "Player"
      elsif line_complete?(line, @computer_marker)
        return "Computer"
      end
    end
    nil
  end

  def line_has_two_markers?(line, marker)
    @squares.values_at(*line).count(marker) == 2
  end

  def find_empty_square_in_line(line)
    line.each do |square|
      return square if square_empty?(square)
    end
    nil
  end

  private

  def board_full?
    available_squares.empty?
  end

  def line_complete?(line, marker)
    @squares.values_at(*line).count(marker) == 3
  end

  def joinor(arr, delimiter = ", ", word = "or")
    case arr.size
    when 0 then ""
    when 1 then arr.first.to_s
    when 2 then arr.join(" #{word} ")
    else
      "#{arr[0...-1].join(delimiter)}#{delimiter}#{word} #{arr.last}"
    end
  end
end

class Score
  include Displayable
  include GameRules

  attr_reader :player_wins, :computer_wins

  def initialize(player, computer)
    @player_wins = 0
    @computer_wins = 0
    @player = player
    @computer = computer
  end

  def update(winner)
    case winner
    when "Player"
      @player_wins += 1
    when "Computer"
      @computer_wins += 1
    end
  end

  def match_over?
    @player_wins == ROUNDS_TO_WIN ||
      @computer_wins == ROUNDS_TO_WIN
  end

  def display
    Message.starred("separator")
    puts format(Message["scoreboard"], @player.name, @player.marker,
                @player_wins, @computer.name, @computer.marker,
                @computer_wins)
    Message.starred("separator")
  end
end

class GrandScore
  attr_reader :grand_winners

  def initialize
    @grand_winners = initialize_grand_winners
  end

  def update(winner)
    if winner == :player
      update_player_grand_win
    elsif winner == :computer
      update_computer_grand_win
    end
  end

  private

  def initialize_grand_winners
    {
      player: 0,
      computer: 0,
      player_streak: 0,
      computer_streak: 0
    }
  end

  def update_player_grand_win
    @grand_winners[:player] += 1
    @grand_winners[:player_streak] += 1
    @grand_winners[:computer_streak] = 0
  end

  def update_computer_grand_win
    @grand_winners[:computer] += 1
    @grand_winners[:computer_streak] += 1
    @grand_winners[:player_streak] = 0
  end
end

class TicTacToeGame
  include Displayable
  include CurrentMatchDisplay
  include GameRules

  attr_reader :player, :computer, :score, :grand_score

  def initialize
    @player = nil
    @computer = nil
    @board = nil
    @score = nil
    @grand_score = GrandScore.new
    @current_player = nil
  end

  def play
    setup_game
    main_game_loop
    display_thank_you(@player.name)
  end

  private

  def setup_game
    Utilities.clear_screen
    player_name = name

    display_welcome(player_name)
    display_rules_prompt

    player_marker = choose_player_marker
    computer_marker = player_marker == "X" ? "O" : "X"

    @player = Human.new(player_name, player_marker)
    @computer = Computer.new(computer_marker, player_marker)
  end

  def main_game_loop
    loop do
      @score = Score.new(@player, @computer)
      play_match
      winner = determine_match_winner
      update_grand_score(winner)
      display_grand_results(@score, @grand_score.grand_winners)
      break unless play_again?
    end
  end

  def play_match
    @current_player = choose_starting_player
    until @score.match_over?
      @board = Board.new(@player.marker, @computer.marker)
      play_round
      update_round_score
    end
  end

  def play_round
    loop do
      display_game_state(@score, @board)
      @current_player.make_move(@board)
      break if @board.game_over?
      switch_players
    end
  end

  def update_round_score
    display_game_state(@score, @board)
    display_round_result(@board.winner)
    Utilities.pause(0.5)
    @score.update(@board.winner)
  end

  def determine_match_winner
    if @score.player_wins == ROUNDS_TO_WIN
      :player
    elsif @score.computer_wins == ROUNDS_TO_WIN
      :computer
    end
  end

  def update_grand_score(winner)
    @grand_score.update(winner)
  end

  def name
    loop do
      Message.prompt("enter_name")
      name = gets.chomp.strip.split.map(&:capitalize).join(" ")
      Utilities.clear_screen
      return name unless name.empty?
      Message.prompt("invalid_name")
    end
  end

  def choose_player_marker
    loop do
      Message.prompt("marker_choice")
      choice = gets.chomp.upcase
      return choice if valid_marker?(choice)
      display_invalid_marker_choice
    end
  end

  def valid_marker?(choice)
    if ["X", "O"].include?(choice)
      Utilities.clear_screen
      true
    else
      false
    end
  end

  def display_invalid_marker_choice
    display_invalid_choice_with_clear
  end

  def choose_starting_player
    input = starting_player_choice
    input = ["player", "computer"].sample if input == "random"
    input == "player" ? @player : @computer
  end

  def starting_player_choice
    loop do
      display_starting_player_options
      input = gets.chomp.downcase
      return input if ["player", "computer", "random"].include?(input)
      display_invalid_choice_with_clear
    end
  end

  def switch_players
    @current_player = @current_player == @player ? @computer : @player
  end

  def play_again?
    loop do
      Message.prompt("play_again")
      answer = gets.chomp.strip.downcase

      response = handle_play_again_response(answer)
      return response unless response.nil?
    end
  end

  def valid_positive_answer?(answer)
    Message["options_pos"].include?(answer)
  end

  def valid_negative_answer?(answer)
    Message["options_neg"].include?(answer)
  end

  def handle_play_again_response(answer)
    if valid_positive_answer?(answer)
      Utilities.clear_screen
      true
    elsif valid_negative_answer?(answer)
      false
    else
      display_invalid_play_again_choice
      nil
    end
  end
end

TicTacToeGame.new.play
