# Todo
# Implemented joinor - done
# Extract messages to YAML? - in progress
# Keep score
# Computer AI: Defense
# Computer AI: Offense
# Computer turn refinements
# Improve the game loop with place_piece and alternate_player method
# Keep track of which square is which number
# Show scoreboard while playing
# Allow entering names?
# Implement ideas from RPS with bonus features

require "yaml"

MESSAGES = YAML.load_file("tic_tac_toe_messages.yml")

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]] # diagonals

INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"

# ROUNDS_TO_WIN = 3

# GRAND_WINNERS = {
#   player: 0,
#   computer: 0,
#   player_streak: 0,
#   computer_streak: 0
# }

def messages(key, **args)
  message = MESSAGES[key.to_s]
  args.empty? ? message : message % args
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

def rules
  messages("rules").each_line do |rule|
    sleep 0.4
    puts rule
  end
end

def get_name
  system "clear"
  loop do
    prompt("enter_name")
    name = gets.chomp.strip.split.map(&:capitalize).join(" ")
    break name unless name.empty?
    prompt("valid_name")
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
  puts "     |     |"
  row_start = row * 3
  puts "  #{board[row_start + 1]}  |  " \
       "#{board[row_start + 2]}  |  " \
       "#{board[row_start + 3]}"
  puts "     |     |"
end

def display_board(board)
  system "clear"
  messages("markers")
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

def joinor(arr, delimiter = ", ", word = "or")
  case arr.size
  when 0 then ""
  when 1 then arr.first.to_s
  when 2 then arr.join(" #{word} ")
  else
    "#{arr[0...-1].join(delimiter)}#{delimiter}#{word} #{arr.last}"
  end
end

def player_places_piece!(board)
  square = ""
  loop do
    prompt("choose_square", squares: joinor(empty_squares(board)))

    square = gets.chomp.to_i
    break if empty_squares(board).include?(square)
    prompt("invalid_choice")
  end
  board[square] = PLAYER_MARKER
end

def computer_places_piece!(board)
  square = empty_squares(board).sample
  board[square] = COMPUTER_MARKER
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
      prompt("invalid_choice")
    end
  end
end

name = get_name
starred_message("welcome", name)
sleep 0.5

loop do
  board = initialize_board

  loop do
    display_board(board)
    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)

    computer_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "It's a draw!"
  end
  play_again(name)
end

# def match(score)
#   until score[:player] == ROUNDS_TO_WIN || score[:computer] == ROUNDS_TO_WIN
#     choice = set_choice
#     computer_choice = computer_move
#     display_choices(choice, computer_choice)
#     update_score(choice, computer_choice, score)
#     win_move_message(choice, computer_choice)
#     display_scoreboard(score)
#     display_results(choice, computer_choice)
#   end
# end

# def grand_update(score)
#   if score[:player] == ROUNDS_TO_WIN
#     GRAND_WINNERS[:player] += 1
#     GRAND_WINNERS[:player_streak] += 1
#     GRAND_WINNERS[:computer_streak] = 0
#   else
#     GRAND_WINNERS[:computer] += 1
#     GRAND_WINNERS[:computer_streak] += 1
#     GRAND_WINNERS[:player_streak] = 0
#   end
# end

# def grand_display(score)
#   sleep 0.4
#   if score[:player] == ROUNDS_TO_WIN
#     puts messages('grand_winner')['player']
#   else
#     puts messages('grand_winner')['computer']
#   end
#   starred_message('separator')
#   puts messages('total_grand_winners', GRAND_WINNERS[:player],
#                 GRAND_WINNERS[:computer]).center(44)
#   starred_message('separator')
# end

# def streak_display
#   if GRAND_WINNERS[:player_streak] >= 2
#     puts(messages('streak')['player'] % GRAND_WINNERS[:player_streak])
#   elsif GRAND_WINNERS[:computer_streak] >= 2
#     puts(messages('streak')['computer'] % GRAND_WINNERS[:computer_streak])
#   end
# end

# loop do
#   score = { player: 0, computer: 0 }
#   match(score)
#   grand_update(score)
#   grand_display(score)
#   streak_display
#   play_again(name)
# end
