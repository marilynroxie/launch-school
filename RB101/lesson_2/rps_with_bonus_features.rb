# Todo
# Fix loop with 'play again' starting with y

require 'yaml'

MESSAGES = YAML.load_file('rps_messages.yml')
VALID_CHOICES = %w(rock r paper p scissors sc lizard l Spock sp)

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
  sleep 2
end

def get_name
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
    choice = gets.chomp.downcase
    system 'clear'
    if choice == 'rules'
      rules
      puts ''
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
  winning_moves = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['rock', 'Spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['paper', 'Spock'],
    'Spock' => ['rock', 'scissors']
  }
  winning_moves[first].include?(second)
end

def display_results(player, computer, score)
  sleep 0.1
  if win?(player, computer)
    prompt('you_won')
    score[:player] += 1
  elsif win?(computer, player)
    prompt('computer_won')
    score[:computer] += 1
  else
    prompt('tie')
  end
end

def play_again(name)
  loop do
    prompt('play_again')
    answer = gets.chomp
    if answer.downcase.start_with?('y')
      system 'clear'
      break
    elsif answer.downcase.start_with?('n')
      prompt('thank_you', name)
      exit
    else
      system 'clear'
      prompt('invalid_choice')
    end
  end
end

rules
name = get_name
prompt('welcome', name)

loop do
  score = { player: 0, computer: 0 }
  loop do
    until score[:player] == 3 || score[:computer] == 3
      choice = set_choice
      computer_choice = computer
      display_choices(choice, computer_choice)
      display_results(choice, computer_choice, score)
    end
    play_again(name)
  end
end
