# Todo
# Add means of accessing rule explanation
# Fix convert choice to accept full move names again
# Fix loop with 'play again' starting with y

require 'yaml'

MESSAGES = YAML.load_file('rps_messages.yml')
VALID_CHOICES = %w(rock paper scissors lizard spock)

def messages(message)
  MESSAGES[message]
end

def prompt(key, *args)
  message = messages(key) % args
  puts("=> #{message}")
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

def rules
  ['Scissors cuts Paper', 'Paper covers Rock', 'Rock crushes lizard', 'Lizard poisons Spock', 'Spock smashes Scissors', 'Scissors decapitates Lizard', 'Lizard eats Paper', 'Paper disproves Spock', 'Spock vaporizes Rock', 'Rock crushes Scissors'].each do |c|
    sleep 0.4
    puts c
  end
end

def convert_move(move)
  moves = {
    'r' => 'rock',
    'p' => 'paper',
    'sc' => 'scissors',
    'li' => 'lizard',
    'sp' => 'Spock'
  }
  if moves.key?(move)
    moves[move]
  elsif moves.value?(move)
    move
  end
end

def set_choice
  choice = ''

  loop do
    prompt('selection')
    choice = gets.chomp.downcase
    system 'clear'
    choice = convert_move(choice)
    if VALID_CHOICES.include?(choice)
      break
    else
      prompt('invalid_choice')
    end
  end
  choice
end

def computer_choice
  VALID_CHOICES.sample
end

def display_choices(choice, computer_choice)
  prompt('display', choice, computer_choice)
end

# Put winning moves into a collection.
# Instead of testing a long series of conditions, you can look up the player's move as a key in a hash.
# The value of that hash element would be a list of moves that the player's move beats.
# For instance, if you look up "rock," you should be able to determine that "rock" defeats either "scissors" or "lizard."

def win?(first, second)
  winning_moves = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['rock', 'Spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['paper', 'Spock'],
    'Spock' => ['rock', 'scissors']
  }
  # (first == 'rock' && second == 'scissors') || (first == 'paper' && second == 'rock') || (first == 'scissors' && second == 'paper')
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

name = get_name
prompt('welcome', name)

loop do
  score = { player: 0, computer: 0 }
  loop do
    until score[:player] == 3 || score[:computer] == 3
      choice = set_choice
      computer_choice
      display_choices(choice, computer_choice)
      display_results(choice, computer_choice, score)
    end
    play_again(name)
  end
end
