require "yaml"

MESSAGES = YAML.load_file("twenty_one_messages.yml")

SUITS = ["♥", "♠", "♦", "♣"]

VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

ROUNDS_TO_WIN = 5

DEALER_STAYS_DEFAULT = 17

GOAL_SCORE_DEFAULT = 21

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

def add_suspense
  3.times do
    sleep 0.5
    puts "."
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

def farewell(name, goal_score)
  system "clear"
  puts messages("thank_you", display_game_name(goal_score), name)
  exit
end

def game_start(name)
  prompt("game_start")
  loop do
    choice = gets.chomp.strip.downcase
    if messages("options_neg").include?(choice)
      farewell(name, GOAL_SCORE_DEFAULT)
    elsif messages("options_pos").include?(choice)
      system "clear"
      return true
    else
      puts messages("invalid_choice")
    end
  end
end

def display_rules(name)
  prompt("rules_question")
  input = gets.chomp
  system "clear"
  if input.downcase == "rules"
    messages("rules").each_line do |rule|
      sleep 0.7
      puts rule
    end
    game_start(name)
  end
end

def get_goal_score
  loop do
    system "clear"
    prompt("enter_goal_score")
    choice = gets.chomp.to_i
    return choice if [21, 31, 41, 51].include?(choice)
  end
end

def get_choice
  loop do
    choice = gets.chomp.strip.downcase
    if messages("options_neg").include?(choice)
      return false
    elsif messages("options_pos").include?(choice)
      return true
    else
      puts messages("invalid_choice")
    end
  end
end

def change_goal_score?(dealer_stays = DEALER_STAYS_DEFAULT,
                       goal_score = GOAL_SCORE_DEFAULT)
  system "clear"
  prompt("change_goal_score", goal_score)
  return [dealer_stays, goal_score] unless get_choice

  goal_score = get_goal_score
  [goal_score - 4, goal_score]
end

def display_game_name(goal_score)
  case goal_score
  when 21 then "Twenty-One"
  when 31 then "Thirty-One"
  when 41 then "Forty-One"
  when 51 then "Fifty-One"
  else "Whatever-One"
  end
end

def display_scoreboard(score)
  starred_message("separator")
  puts messages("scoreboard", score[:player], score[:dealer])
  starred_message("separator")
end

def display_round_data(round, goal_score, score)
  puts messages("round", display_game_name(goal_score), round)
  display_scoreboard(score)
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def display_card_lines(card)
  suit, value = card
  [
    "┌─────┐",
    "│#{value.ljust(2)}   │",
    "│  #{suit}  │",
    "│   #{value.rjust(2)}│",
    "└─────┘"
  ]
end

def display_cards(cards, display_hidden: false)
  card_lines = cards.map { |card| display_card_lines(card) }

  if display_hidden
    hidden_card_lines = messages("hidden_card").split("\n")
    card_lines << hidden_card_lines
  end

  5.times do |i|
    puts card_lines.map { |card| card[i] }.join("  ")
  end
end

def display_value_text(value)
  case value
  when "A" then "Ace"
  when "K" then "King"
  when "Q" then "Queen"
  when "J" then "Jack"
  else value
  end
end

def display_suit_text(suit)
  case suit
  when "♥" then "Hearts"
  when "♠" then "Spades"
  when "♣" then "Clubs"
  when "♦" then "Diamonds"
  else "?"
  end
end

def format_card(card)
  "#{display_value_text(card[1])} of #{display_suit_text(card[0])}"
end

def format_two_cards(cards)
  [
    format_card(cards[0]),
    "and",
    format_card(cards[1])
  ].join(" ")
end

def format_multiple_cards(cards)
  cards.map { |card| format_card(card) }.join(", ")
end

def format_cards(cards)
  if cards.size == 2
    format_two_cards(cards)
  else
    format_multiple_cards(cards)
  end
end

def total(cards, goal_score)
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
    sum -= 10 if sum > goal_score
  end

  sum
end

def display_initial_cards_data(player_cards, dealer_cards, player_total)
  sleep 0.3
  puts messages("dealer_hand")
  display_cards([dealer_cards[0]], display_hidden: true)
  puts messages("initial_dealer", format_cards([dealer_cards[0]]))
  puts messages("player_hand")
  display_cards(player_cards)
  puts messages("initial_player", format_cards(player_cards), player_total)
end

def distribute_cards(deck, player_cards, dealer_cards, goal_score)
  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end
  player_total = total(player_cards, goal_score)
  dealer_total = total(dealer_cards, goal_score)
  display_initial_cards_data(player_cards, dealer_cards, player_total)
  [player_total, dealer_total]
end

def get_hit_or_stay
  loop do
    prompt("hit_or_stay")
    decision = gets.chomp.strip.downcase
    return decision if messages("hit_stay_options").include?(decision)
    puts messages("invalid_hit_or_stay")
  end
end

def player_hit(deck, player_cards, goal_score)
  player_cards << deck.pop
  player_total = total(player_cards, goal_score)
  puts messages("you_hit")
  puts messages("updated_player", format_cards(player_cards), player_total)
  display_cards(player_cards)
  player_total
end

def busted?(totals, goal_score)
  totals > goal_score
end

def player_turn(deck, player_cards, goal_score, player_total)
  loop do
    case get_hit_or_stay
    when "h", "hit"
      player_total = player_hit(deck, player_cards, goal_score)
      return [player_cards, player_total] if busted?(player_total, goal_score)
    when "s", "stay"
      return [player_cards, player_total]
    end
  end
end

def dealer_turn(deck, dealer_cards, goal_score, dealer_stays)
  puts messages("dealer_turn")
  dealer_total = total(dealer_cards, goal_score)

  loop do
    break if dealer_total >= dealer_stays

    puts messages("dealer_hit")
    dealer_cards << deck.pop
    dealer_total = total(dealer_cards, goal_score)
    puts messages("updated_dealer_cards", format_cards(dealer_cards))
    puts messages("dealer_total", dealer_total)
  end

  dealer_total
end

def detect_result(dealer_total, player_total, goal_score)
  if busted?(player_total, goal_score)
    :player_busted
  elsif busted?(dealer_total, goal_score)
    :dealer_busted
  elsif dealer_total == player_total
    :tie
  else
    dealer_total > player_total ? :dealer : :player
  end
end

def display_result(dealer_total, player_total, goal_score)
  result = detect_result(dealer_total, player_total, goal_score)
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

def player_bust?(player_total, goal_score)
  if busted?(player_total, goal_score)
    true
  else
    puts messages("you_stayed", player_total)
    false
  end
end

def dealer_bust?(dealer_total, goal_score)
  if busted?(dealer_total, goal_score)
    true
  else
    puts messages("dealer_stay", dealer_total)
    false
  end
end

def update_score(score, dealer_total, player_total, goal_score)
  win = detect_result(dealer_total, player_total, goal_score)
  if win == :player || win == :dealer_busted
    score[:player] += 1
  elsif win == :dealer || win == :player_busted
    score[:dealer] += 1
  end
end

def end_round_sequence(score, dealer_total, player_total, goal_score)
  update_score(score, dealer_total, player_total, goal_score)
  sleep 0.7
  display_result(dealer_total, player_total, goal_score)
  sleep 0.7
end

def display_final_result(dealer_cards, player_cards, dealer_total,
                         player_total, score)
  display_scoreboard(score)
  puts messages("final_dealer_hand")
  display_cards(dealer_cards)
  puts messages("final_dealer_total", format_cards(dealer_cards), dealer_total)
  puts messages("final_player_hand")
  display_cards(player_cards)
  puts messages("final_player_total", format_cards(player_cards), player_total)
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

def continue?(name, score, goal_score)
  if score[:player] == ROUNDS_TO_WIN || score[:dealer] == ROUNDS_TO_WIN
    return false
  end

  prompt("continue")
  choice = get_choice

  unless choice
    farewell(name, goal_score)
  end

  choice
end

def play_again?(name, goal_score)
  prompt("play_again")
  choice = get_choice
  farewell(name, goal_score) unless choice
  choice
end

name = get_name
system "clear"
puts messages("welcome", name)
display_rules(name)
grand_winners = {
  player: 0,
  dealer: 0,
  player_streak: 0,
  dealer_streak: 0
}

loop do
  dealer_stays, goal_score = change_goal_score?(DEALER_STAYS_DEFAULT,
                                                GOAL_SCORE_DEFAULT)
  round = 0
  score = { player: 0, dealer: 0 }
  until score[:player] == ROUNDS_TO_WIN || score[:dealer] == ROUNDS_TO_WIN
    system "clear"
    round += 1
    display_round_data(round, goal_score, score)
    deck = initialize_deck
    player_cards = []
    dealer_cards = []
    player_total, dealer_total = distribute_cards(deck, player_cards,
                                                  dealer_cards, goal_score)
    player_cards, player_total = player_turn(deck, player_cards, goal_score,
                                             player_total)

    if player_bust?(player_total, goal_score)
      end_round_sequence(score, dealer_total, player_total, goal_score)
      display_final_result(dealer_cards, player_cards,
                           dealer_total, player_total,
                           score)
      break unless continue?(name, score, goal_score)
      next
    end

    add_suspense
    dealer_total = dealer_turn(deck, dealer_cards, goal_score, dealer_stays)
    add_suspense

    if dealer_bust?(dealer_total, goal_score)
      end_round_sequence(score, dealer_total, player_total, goal_score)
      display_final_result(dealer_cards, player_cards,
                           dealer_total, player_total,
                           score)
      break unless continue?(name, score, goal_score)
      next
    end

    end_round_sequence(score, dealer_total, player_total, goal_score)
    display_final_result(dealer_cards, player_cards, dealer_total, player_total,
                         score)
    break unless continue?(name, score, goal_score)
  end
  display_scoreboard(score)
  grand_update(score, grand_winners)
  grand_display(score, grand_winners)
  break unless play_again?(name, goal_score)
end
