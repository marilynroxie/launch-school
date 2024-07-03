# Todo
# Keep track of which square is which number

require "yaml"

MESSAGES = YAML.load_file("tic_tac_toe_messages.yml")

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]] # diagonals

INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"

ROUNDS_TO_WIN = 5

GRAND_WINNERS = {
  player: 0,
  computer: 0,
  player_streak: 0,
  computer_streak: 0
}

def messages(message, *args)
  args.empty? ? MESSAGES[message] : MESSAGES[message] % args
end

def prompt(key, **args)
  message = messages(key)
  message = format(message, **args) if args.any?
  puts("=> #{message}")
end

def starred_message(key, *args)
  message = messages(key)
  message = message % args if args.any?
  puts("* #{message} *")
end

def display_rules
  prompt("rules_question")
  input = gets.chomp
  system "clear"
  if input.downcase == "rules"
    messages("rules").each_line do |rule|
      sleep 0.4
      puts rule
    end
  end
end

def get_name
  system "clear"
  loop do
    prompt("enter_name")
    name = gets.chomp.strip.split.map(&:capitalize).join(" ")
    system "clear"
    break name unless name.empty?
    prompt("invalid_name")
  end
end

def display_markers
  puts messages("markers")
end

def display_line(board)
  3.times do |row|
    display_row(board, row)
    puts messages("separator") unless row == 2
  end
end

def display_row(board, row)
  puts messages("column_line")
  row_start = row * 3
  puts "  #{board[row_start + 1]}  |  " \
       "#{board[row_start + 2]}  |  " \
       "#{board[row_start + 3]}"

  puts messages("column_line")
end

def display_board(score, board)
  system "clear"
  display_scoreboard(score)
  display_markers
  puts ""
  display_line(board)
  puts ""
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(board)
  board.keys.select { |num| board[num] == INITIAL_MARKER }
end

def turn
  input = nil
  loop do
    messages("who_goes_first").each_line do |turn|
      sleep 0.2
      puts turn
    end
    input = gets.chomp.downcase
    break if ["player", "computer", "random"].include?(input)
    puts messages("invalid_choice")
    sleep 0.5
    system "clear"
  end
  input = ["player", "computer"].sample if input == "random"
  input
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

def player_places_piece!(score, board)
  square = ""
  loop do
    display_board(score, board)
    prompt("choose_square", squares: joinor(empty_squares(board)))

    input = gets.chomp
    if empty_squares(board).include?(input.to_i)
      square = input.to_i
      break
    else
      puts messages("invalid_choice")
      sleep 0.5
    end
  end
  board[square] = PLAYER_MARKER
end

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def pick_square(board, marker)
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, board, marker)
    return square if square
  end
  nil
end

def offensive_square(board)
  pick_square(board, COMPUTER_MARKER)
end

def defensive_square(board)
  pick_square(board, PLAYER_MARKER)
end

def center_square(board)
  5 if board[5] == INITIAL_MARKER
end

def random_square(board)
  empty_squares(board).sample
end

def computer_places_piece!(board)
  sleep 0.2
  square = offensive_square(board) ||
           defensive_square(board) ||
           center_square(board) ||
           random_square(board)
  board[square] = COMPUTER_MARKER if square
end

def alternate_player(turn)
  turn == "player" ? "computer" : "player"
end

def place_piece!(turn, score, board)
  loop do
    if turn == "player"
      player_places_piece!(score, board)
    else
      computer_places_piece!(board)
    end

    break if someone_won?(board) || board_full?(board)
    turn = alternate_player(turn)
  end
end

def board_full?(board)
  empty_squares(board).empty?
end

def detect_winner(board)
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(PLAYER_MARKER) == 3
      return "Player"
    elsif board.values_at(*line).count(COMPUTER_MARKER) == 3
      return "Computer"
    end
  end
  nil
end

def someone_won?(board)
  !!detect_winner(board)
end

def update_score(win, score)
  if win == "Player"
    score[:player] += 1
  elsif win == "Computer"
    score[:computer] += 1
  end
end

def display_scoreboard(score)
  starred_message("separator")
  puts messages("scoreboard", score[:player], score[:computer])
  starred_message("separator")
end

def score_sequence(score, board)
  display_board(score, board)
  display_results(detect_winner(board))
  sleep 0.5
  update_score(detect_winner(board), score)
end

def match(turn, score)
  until score[:player] == ROUNDS_TO_WIN || score[:computer] == ROUNDS_TO_WIN
    board = initialize_board
    place_piece!(turn, score, board)
    score_sequence(score, board)
  end
end

def grand_update(score)
  if score[:player] == ROUNDS_TO_WIN
    GRAND_WINNERS[:player] += 1
    GRAND_WINNERS[:player_streak] += 1
    GRAND_WINNERS[:computer_streak] = 0
  elsif score[:computer] == ROUNDS_TO_WIN
    GRAND_WINNERS[:computer] += 1
    GRAND_WINNERS[:computer_streak] += 1
    GRAND_WINNERS[:player_streak] = 0
  end
end

def grand_display(score)
  sleep 0.4
  system "clear"
  if score[:player] == ROUNDS_TO_WIN
    puts messages("grand_winner")["player"]
  elsif score[:computer] == ROUNDS_TO_WIN
    puts messages("grand_winner")["computer"]
  end
  starred_message("separator")
  puts messages("total_grand_winners", GRAND_WINNERS[:player],
                GRAND_WINNERS[:computer])
  starred_message("separator")
end

def streak_display
  if GRAND_WINNERS[:player_streak] >= 2
    puts(messages("streak")["player"] % GRAND_WINNERS[:player_streak])
  elsif GRAND_WINNERS[:computer_streak] >= 2
    puts(messages("streak")["computer"] % GRAND_WINNERS[:computer_streak])
  end
end

def display_results(win)
  if win == "Player"
    puts(messages("round_result")["you_won"])
  elsif win == "Computer"
    puts(messages("round_result")["computer_won"])
  else
    puts(messages("round_result")["draw"])
  end
end

def play_again(name)
  loop do
    prompt("play_again")
    answer = gets.chomp.strip.downcase
    if messages("options_pos").include?(answer)
      system "clear"

      break
    elsif messages("options_neg").include?(answer)
      starred_message("thank_you", name)
      exit
    else
      system "clear"
      puts messages("invalid_choice")
    end
  end
end

name = get_name
starred_message("welcome", name)
display_rules

loop do
  score = { player: 0, computer: 0 }
  match(turn, score)
  grand_update(score)
  grand_display(score)
  streak_display
  play_again(name)
end
