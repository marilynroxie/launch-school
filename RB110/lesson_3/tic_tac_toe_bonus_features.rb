# 1. Display the initial empty 3x3 board.
# 2. Ask the user to mark a square.
# 3. Computer marks a square.
# 4. Display the updated board state.
# 5. If winner, display winner.
# 6. If board is full, display tie.
# 7. If neither winner nor board is full, go to #2
# 8. Play again?
# 9. If yes, go to #1
# 10. Good bye!

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]] # diagonals

INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"

def prompt(msg)
  puts "=> #{msg}"
end

def display_markers
  puts "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}"
end

def display_line(brd)
  3.times do |row|
    display_row(brd, row)
    puts "----------------" unless row == 2
  end
end

def display_row(brd, row)
  puts "     |     |"
  puts "  #{brd[(row * 3) + 1]}  |  #{brd[(row * 3) + 2]}  |  #{brd[(row * 3) + 3]}"
  puts "     |     |"
end

def display_board(brd)
  system "clear"
  display_markers
  puts ""
  display_line(brd)
  puts ""
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
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

def player_places_piece!(brd)
  square = ""
  loop do
    prompt "Choose a square to place a piece: #{joinor(empty_squares(brd))}"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return "Player"
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return "Computer"
    end
  end
  nil
end

def someone_won?(brd)
  !!detect_winner(brd)
end

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
    prompt "It's a tie!"
  end

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt "Thanks for playing Tic Tac Toe! Good bye!"
