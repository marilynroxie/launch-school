# Todo
# 1. Initialize deck
# 2. Deal cards to player and dealer
# 3. Player turn: hit or stay
#   - repeat until bust or "stay"
# 4. If player bust, dealer wins.
# 5. Dealer turn: hit or stay
#   - repeat until total >= 17
# 6. If dealer bust, player wins.
# 7. Compare cards and declare winner.

require "yaml"

MESSAGES = YAML.load_file("twenty_one_messages.yml")

SUITS = ["♠", "♥", "♦", "♣"]

VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

GOAL_SCORE = 21

def messages(message, *args)
  args.empty? ? MESSAGES[message] : MESSAGES[message] % args
end

def prompt(msg)
  puts "=> #{msg}"
end

# def prompt(key, **args)
#   message = messages(key)
#   message = format(message, **args) if args.any?
#   puts("=> #{message}")
# end

# def starred_message(key, *args)
#   message = messages(key)
#   message = message % args if args.any?
#   puts("* #{message} *")
# end

def get_name
  system "clear"
  loop do
    puts messages("enter_name")
    name = gets.chomp.strip.split.map(&:capitalize).join(" ")
    system "clear"
    break name unless name.empty?
    puts messages("invalid_name")
  end
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += if value == "A"
             11
           elsif value.to_i == 0
             10
           else
             value.to_i
           end
  end

  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > GOAL_SCORE
  end

  sum
end

def busted?(cards)
  total(cards) > GOAL_SCORE
end

def detect_result(dealer_cards, player_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > GOAL_SCORE
    :player_busted
  elsif dealer_total > GOAL_SCORE
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def display_result(dealer_cards, player_cards)
  result = detect_result(dealer_cards, player_cards)

  case result
  when :player_busted
    puts(messages("round_result")["you_busted"])
  when :dealer_busted
    puts(messages("round_result")["dealer_busted"])
  when :player
    puts(messages("round_result")["you_win"])
  when :dealer
    puts(messages("round_result")["dealer_wins"])
  when :tie
    puts(messages("round_result")["tie"])
  end
end

def play_again?
  puts messages("separator")
  puts messages("play_again")
  answer = gets.chomp
  answer.downcase.start_with?("y")
end

name = get_name
puts messages("welcome", name)

loop do
  deck = initialize_deck
  player_cards = []
  dealer_cards = []

  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  prompt "Dealer has #{dealer_cards[0]} and ?"
  prompt "You have: #{player_cards[0]} and #{player_cards[1]}, " \
         "for a total of #{total(player_cards)}."

  loop do
    player_turn = nil
    loop do
      puts messages("hit_or_stay")
      player_turn = gets.chomp.downcase
      break if ["h", "s"].include?(player_turn)
      puts messages("invalid_hit_or_stay")
    end

    if player_turn == "h"
      player_cards << deck.pop
      prompt "You chose to hit!"
      prompt "Your cards are now: #{player_cards}"
      prompt "Your total is now: #{total(player_cards)}"
    end

    break if player_turn == "s" || busted?(player_cards)
  end

  if busted?(player_cards)
    display_result(dealer_cards, player_cards)
    play_again? ? next : break
  else
    prompt "You stayed at #{total(player_cards)}"
  end

  prompt "Dealer turn..."

  loop do
    break if total(dealer_cards) >= 17

    prompt "Dealer hits!"
    dealer_cards << deck.pop
    prompt "Dealer's cards are now: #{dealer_cards}"
  end

  if busted?(dealer_cards)
    prompt "Dealer total is now: #{total(dealer_cards)}"
    display_result(dealer_cards, player_cards)
    play_again? ? next : break
  else
    prompt "Dealer stays at #{total(dealer_cards)}"
  end

  puts messages("separator")
  prompt "Dealer has #{dealer_cards}, for a total of: #{total(dealer_cards)}"
  prompt "Player has #{player_cards}, for a total of: #{total(player_cards)}"
  puts messages("separator")

  display_result(dealer_cards, player_cards)

  break unless play_again?
end

puts messages("separator")
puts messages("thank_you", name)
