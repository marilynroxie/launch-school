require "yaml"

MESSAGES = YAML.load_file("twenty_one_messages.yml")

SUITS = ["♠", "♥", "♦", "♣"]

VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

GOAL_SCORE = 21

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

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def distribute_cards(deck, player_cards, dealer_cards)
  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end
  puts messages("initial_dealer", dealer_cards[0])
  puts messages("initial_player", player_cards[0], player_cards[1],
                total(player_cards))
  return player_cards, dealer_cards
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
  sleep 0.3
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
  prompt("play_again")
  answer = gets.chomp
  answer.downcase.start_with?("y")
end

name = get_name
system "clear"
puts messages("welcome", name)

loop do
  deck = initialize_deck
  player_cards = []
  dealer_cards = []

  distribute_cards(deck, player_cards, dealer_cards)

  loop do
    player_turn = nil
    loop do
      prompt("hit_or_stay")
      player_turn = gets.chomp.downcase
      break if ["h", "s"].include?(player_turn)
      puts messages("invalid_hit_or_stay")
    end

    if player_turn == "h"
      player_cards << deck.pop
      puts messages("you_hit")
      puts messages("updated_player", player_cards, total(player_cards))
    end

    break if player_turn == "s" || busted?(player_cards)
  end

  if busted?(player_cards)
    display_result(dealer_cards, player_cards)
    play_again? ? next : break
  else
    puts messages("you_stayed", total(player_cards))
  end

  puts messages("dealer_turn")

  loop do
    break if total(dealer_cards) >= 17

    puts messages("dealer_hit")
    dealer_cards << deck.pop
    sleep 0.3
    puts messages("updated_dealer_cards", dealer_cards)
  end

  if busted?(dealer_cards)
    puts messages("dealer_total", total(dealer_cards))
    display_result(dealer_cards, player_cards)
    play_again? ? next : break
  else
    puts messages("dealer_stay", total(dealer_cards))
  end

  puts messages("separator")
  puts messages("final_dealer_total", dealer_cards, total(dealer_cards))
  puts messages("final_player_total", player_cards, total(player_cards))
  puts messages("separator")

  display_result(dealer_cards, player_cards)

  break unless play_again?
end
system "clear"
puts messages("separator")
puts messages("thank_you", name)
