# Todo
# Improve display of persistent scoreboard
# Add a constant to keep track of grand winners?
# Differentiating more between prompts and messages?
# Add description of the winning move

require 'yaml'

MESSAGES = YAML.load_file('rps_messages.yml')
VALID_CHOICES = %w(Rock R Paper P Scissors Sc Lizard L Spock Sp)

def messages(message)
  MESSAGES[message]
end

def prompt(key, *args)
  message = messages(key) % args
  puts("=> #{message}")
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

def computer
  convert_move(VALID_CHOICES.sample)
end

def display_choices(choice, computer_choice)
  prompt('display', choice, computer_choice)
end

def win?(first, second)
  messages('winning_moves')[first].include?(second)
end

def update_score(player, computer, score)
  if win?(player, computer)
    score[:player] += 1
  elsif win?(computer, player)
    score[:computer] += 1
  end
end

def display_scoreboard(score)
  if score[:player] >= 1 || score[:computer] >= 1
    prompt('scoreboard', score[:player],
           score[:computer])
  end
end

def display_results(player, computer)
  if win?(player, computer)
    prompt('you_won')
  elsif win?(computer, player)
    prompt('computer_won')
  else
    prompt('tie')
  end
end

def grand_display(score)
  sleep 0.4
  if score[:player] == 3
    puts MESSAGES['grand_winner']['player'][0]
  else
    puts MESSAGES['grand_winner']['computer'][0]
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
      prompt('thank_you', name)
      exit
    else
      system 'clear'
      prompt('invalid_choice')
    end
  end
end

name = get_name
prompt('welcome', name)

loop do
  score = { player: 0, computer: 0 }
  until score[:player] == 3 || score[:computer] == 3
    choice = set_choice
    computer_choice = computer
    display_choices(choice, computer_choice)
    update_score(choice, computer_choice, score)
    display_scoreboard(score)
    display_results(choice, computer_choice)
  end
  grand_display(score)
  play_again(name)
end
