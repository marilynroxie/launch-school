# Todo
# Calculating the total - use local variable instead
# play_again? investigation
# End of round output
# Grand total of rounds - 5
# Add rules option
# Constants for other winning score options

require "yaml"

MESSAGES = YAML.load_file("twenty_one_messages.yml")

SUITS = ["♠", "♥", "♦", "♣"]

VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

ROUNDS_TO_WIN = 5

DEALER_STAYS = 17

GOAL_SCORE = 21

def messages(message, *args)
  args.empty? ? MESSAGES[message] : MESSAGES[message] % args
end

def prompt(key, *args)
  message = messages(key, *args)
  puts("=> #{message}")
end

def starred_message(key, *args)
  message = messages(key, *args)
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

def player_decision
  loop do
    prompt("hit_or_stay")
    decision = gets.chomp.downcase
    return decision if ["h", "s"].include?(decision)
    puts messages("invalid_hit_or_stay")
  end
end

def player_hit(deck, player_cards)
  player_cards << deck.pop
  puts messages("you_hit")
  puts messages("updated_player", player_cards, total(player_cards))
end

def hit_stay(deck, player_cards)
  loop do
    player_turn = player_decision

    if player_turn == "h"
      player_hit(deck, player_cards)
    end

    break if player_turn == "s" || busted?(player_cards)
  end
  [deck, player_cards]
end

def dealer_turn(deck, dealer_cards)
  puts messages("dealer_turn")

  loop do
    break if total(dealer_cards) >= DEALER_STAYS

    puts messages("dealer_hit")
    dealer_cards << deck.pop
    sleep 0.3
    puts messages("updated_dealer_cards", dealer_cards)
  end
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

def player_bust?(player_cards, dealer_cards)
  if busted?(player_cards)
    display_result(dealer_cards, player_cards)
    true
  else
    puts messages("you_stayed", total(player_cards))
    false
  end
end

def dealer_bust?(dealer_cards, player_cards)
  if busted?(dealer_cards)
    puts messages("dealer_total", total(dealer_cards))
    display_result(dealer_cards, player_cards)
    true
  else
    puts messages("dealer_stay", total(dealer_cards))
    false
  end
end

# def match(score)
#   sleep 0.3
#   until score[:player] == ROUNDS_TO_WIN || score[:dealer] == ROUNDS_TO_WIN
#   end
#   score_sequence(score, dealer_cards, player_cards)
# end

def display_final_result(dealer_cards, player_cards)
  puts messages("separator")
  puts messages("final_dealer_total", dealer_cards, total(dealer_cards))
  puts messages("final_player_total", player_cards, total(player_cards))
  puts messages("separator")

  display_result(dealer_cards, player_cards)
end

def update_score(score, dealer_cards, player_cards)
  win = detect_result(dealer_cards, player_cards)
  if win == :dealer_busted || win == :player
    score[:player] += 1
  elsif win == :player_busted || win == :dealer
    score[:dealer] += 1
  end
end

def score_sequence(score, dealer_cards, player_cards)
  display_result(dealer_cards, player_cards)
  sleep 0.5
  update_score(score, dealer_cards, player_cards)
  display_scoreboard(score)
end

def display_scoreboard(score)
  starred_message("separator")
  puts messages("scoreboard", score[:player], score[:dealer])
  starred_message("separator")
end

def grand_update(score, grand_winners)
  if score[:player] == ROUNDS_TO_WIN
    grand_winners[:player] += 1
    grand_winners[:player_streak] += 1
    grand_winners[:dealer_streak] = 0
  elsif score[:dealer] == ROUNDS_TO_WIN
    grand_winners[:dealer] += 1
    grand_winners[:dealer_streak] += 1
    grand_winners[:player_streak] = 0
  end
end

def grand_display(score, grand_winners)
  sleep 0.4
  # system "clear"
  display_scoreboard(score)
  if score[:player] == ROUNDS_TO_WIN
    puts messages("grand_winner")["player"]
  elsif score[:dealer] == ROUNDS_TO_WIN
    puts messages("grand_winner")["dealer"]
  end
  starred_message("separator")
  puts messages("total_grand_winners", grand_winners[:player],
                grand_winners[:dealer])
  starred_message("separator")
end

def farewell(name)
  system "clear"
  puts messages("separator")
  puts messages("thank_you", name)
end

def play_again?(name)
  loop do
    puts ""
    puts messages("separator")
    prompt("play_again")
    answer = gets.chomp.strip.downcase
    if messages("options_neg").include?(answer)
      farewell(name)
      return false
    elsif messages("options_pos").include?(answer)
      return true
    else
      system "clear"
      puts messages("invalid_choice")
    end
  end
end

name = get_name
system "clear"
puts messages("welcome", name)
grand_winners = {
  player: 0,
  dealer: 0,
  player_streak: 0,
  dealer_streak: 0
}

loop do
  score = { player: 0, dealer: 0 }
  loop do
    until score[:player] == ROUNDS_TO_WIN || score[:dealer] == ROUNDS_TO_WIN
      deck = initialize_deck
      player_cards = []
      dealer_cards = []
      distribute_cards(deck, player_cards, dealer_cards)
      deck, player_cards = hit_stay(deck, player_cards)

      if player_bust?(player_cards, dealer_cards)
        score[:dealer] += 1
        next if play_again?(name)
        break
      end

      dealer_turn(deck, dealer_cards)

      if dealer_bust?(dealer_cards, player_cards)
        score[:player] += 1
        next if play_again?(name)
        break
      end
      score_sequence(score, dealer_cards, player_cards)
      display_final_result(dealer_cards, player_cards)
    end
  end
  grand_update(score, grand_winners)
  grand_display(score, grand_winners)
  break unless play_again?(name)
end