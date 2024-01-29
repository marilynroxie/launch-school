require 'yaml'

MESSAGES = YAML.load_file('rps_messages.yml')
VALID_CHOICES = %w(Rock R Paper P Scissors Sc Lizard L Spock Sp)
GRAND_WINNERS = {
  player: 0,
  computer: 0,
  player_streak: 0,
  computer_streak: 0
}

def messages(message, *args)
  args.empty? ? MESSAGES[message] : MESSAGES[message] % args
end

def prompt(key, *args)
  message = messages(key) % args
  puts("=> #{message}")
end

def starred_message(key, *args)
  message = messages(key) % args
  puts("* #{message} *")
end

def rules
  messages('rules').each_line do |rule|
    sleep 0.4
    puts rule
  end
end

def get_name
  system 'clear'
  loop do
    prompt('enter_name')
    name = gets.chomp.strip.capitalize
    system 'clear'
    break name unless name.empty?
    prompt('valid_name')
  end
end

def convert_move(move)
  messages('moves').key?(move) ? messages('moves')[move] : move
end

def set_choice
  choice = ''

  loop do
    prompt('selection')
    choice = gets.chomp.capitalize
    system 'clear'
    if choice == 'Rules'
      rules
    elsif VALID_CHOICES.include?(convert_move(choice))
      break
    else
      prompt('invalid_choice')
    end
  end
  convert_move(choice)
end

def computer_move
  convert_move(VALID_CHOICES.sample)
end

def display_choices(player, computer)
  puts messages('display', player, computer)
  sleep 0.2
end

def win?(player, computer)
  messages('winning_moves')[player].include?(computer)
end

def win_move_message(player, computer)
  if win?(player, computer)
    puts(messages('winning_moves_lines')[player].find do |line|
      line.include?(computer)
    end)
  elsif win?(computer, player)
    puts(messages('winning_moves_lines')[computer].find do |line|
      line.include?(player)
    end)
  else
    puts messages('no_effect', player, computer)
  end
end

def update_score(player, computer, score)
  if win?(player, computer)
    score[:player] += 1
  elsif win?(computer, player)
    score[:computer] += 1
  end
end

def display_scoreboard(score)
  starred_message('separator')
  puts messages('scoreboard', score[:player], score[:computer]).center(44)
  starred_message('separator')
end

def display_results(player, computer)
  if win?(player, computer)
    puts(messages('round_result')['you_won'])
  elsif win?(computer, player)
    puts(messages('round_result')['computer_won'])
  else
    puts(messages('round_result')['tie'])
  end
end

def grand_update(score)
  if score[:player] == 3
    GRAND_WINNERS[:player] += 1
    GRAND_WINNERS[:player_streak] += 1
    GRAND_WINNERS[:computer_streak] = 0
  else
    GRAND_WINNERS[:computer] += 1
    GRAND_WINNERS[:computer_streak] += 1
    GRAND_WINNERS[:player_streak] = 0
  end
end

def grand_display(score)
  sleep 0.4
  if score[:player] == 3
    puts messages('grand_winner')['player']
  else
    puts messages('grand_winner')['computer']
  end
  starred_message('separator')
  puts messages('total_grand_winners', GRAND_WINNERS[:player],
                GRAND_WINNERS[:computer]).center(44)
  starred_message('separator')
end

def streak_display
  if GRAND_WINNERS[:player_streak] >= 2
    puts(messages('streak')['player'] % GRAND_WINNERS[:player_streak])
  elsif GRAND_WINNERS[:computer_streak] >= 2
    puts(messages('streak')['computer'] % GRAND_WINNERS[:computer_streak])
  end
end

def play_again(name)
  loop do
    prompt('play_again')
    answer = gets.chomp.downcase
    if messages('options_pos').include?(answer)
      system 'clear'
      break
    elsif messages('options_neg').include?(answer)
      starred_message('thank_you', name)
      exit
    else
      system 'clear'
      prompt('invalid_choice')
    end
  end
end

name = get_name
starred_message('welcome', name)

loop do
  score = { player: 0, computer: 0 }
  until score[:player] == 3 || score[:computer] == 3
    choice = set_choice
    computer_choice = computer_move
    display_choices(choice, computer_choice)
    update_score(choice, computer_choice, score)
    win_move_message(choice, computer_choice)
    display_scoreboard(score)
    display_results(choice, computer_choice)
  end
  grand_update(score)
  grand_display(score)
  streak_display
  play_again(name)
end
