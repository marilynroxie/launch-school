require 'yaml'

module Message
  MESSAGES = YAML.load_file('oop_twenty_one_bonus_features.yml')

  def self.[](key, *args)
    args.empty? ? MESSAGES[key] : MESSAGES[key] % args
  end

  def self.prompt(key, *args)
    message = self[key, *args]
    puts("=> #{message}")
  end

  def self.starred(key, *args)
    message = self[key, *args]
    puts("* #{message} *")
  end
end

class Utilities
  def self.add_suspense
    3.times do
      sleep 0.5
      puts '.'
    end
  end

  def self.clear_screen
    system('clear') || system('cls')
  end
end

module CurrentMatchDisplay
  def display_cards_visually(cards, display_hidden: false)
    card_lines = cards.map(&:display_lines)

    if display_hidden
      hidden_lines = cards.first.hidden_card_lines
      card_lines << hidden_lines
    end

    5.times do |i|
      puts card_lines.map { |card| card[i] }.join('  ')
    end
  end

  def display_initial_cards
    sleep 0.3
    puts Message['dealer_hand']
    display_cards_visually([@dealer.cards.first], display_hidden: true)
    puts Message['initial_dealer', @dealer.show_initial_cards.first]
    puts Message['player_hand']
    display_cards_visually(@player.cards)
    puts Message['initial_player', @player.show_cards,
                 @player.total(@goal_score)]
  end

  def display_final_results
    @score.display
    puts Message['final_dealer_hand']
    display_cards_visually(@dealer.cards)
    puts Message['final_dealer_total', @dealer.show_cards,
                 @dealer.total(@goal_score)]
    puts Message['final_player_hand']
    display_cards_visually(@player.cards)
    puts Message['final_player_total', @player.show_cards,
                 @player.total(@goal_score)]
  end

  def display_round_info
    puts Message['round', display_game_name, @round]
    @score.display
  end

  def display_round_result(result)
    sleep 0.7
    case result
    when :player_busted
      puts Message['round_result']['you_busted']
    when :dealer_busted
      puts Message['round_result']['dealer_busted']
    when :player
      puts Message['round_result']['you_win']
    when :dealer
      puts Message['round_result']['dealer_wins']
    when :tie
      puts Message['round_result']['tie']
    end
    sleep 0.7
  end

  def display_grand_winner_info
    update_grand_winners
    sleep 0.4

    if @score.player_wins == TwentyOne::ROUNDS_TO_WIN
      puts Message['grand_winner']['player']
    elsif @score.dealer_wins == TwentyOne::ROUNDS_TO_WIN
      puts Message['grand_winner']['dealer']
    end

    Message.starred('separator')
    puts Message['total_grand_winners',
                 @grand_winners[:player],
                 @grand_winners[:dealer]]
    Message.starred('separator')
  end

  def display_game_state
    Utilities.clear_screen
    @score.display
    puts Message['round', display_game_name, @round]
  end
end

module Displayable
  def display_full_rules
    Message['full_rules'].each_line do |rule|
      sleep 0.7
      puts rule
    end
    ask_start
  end

  def display_farewell
    Utilities.clear_screen
    Message.starred('thank_you', display_game_name, @player_name)
    exit
  end

  def display_game_name
    case @goal_score
    when 21 then 'Twenty-One'
    when 31 then 'Thirty-One'
    when 41 then 'Forty-One'
    when 51 then 'Fifty-One'
    else 'Whatever-One'
    end
  end
end

module Hand
  attr_accessor :cards

  def add_card(card)
    cards << card
  end

  def total(goal_score)
    values = cards.map(&:value)

    sum = 0
    values.each do |value|
      sum += if value == 'A'
               11
             elsif value.to_i.zero?
               10
             else
               value.to_i
             end
    end

    values.count('A').times do
      sum -= 10 if sum > goal_score
    end

    sum
  end

  def busted?(goal_score)
    total(goal_score) > goal_score
  end

  def reset_hand
    self.cards = []
  end

  def show_cards
    cards.map(&:to_s).join(', ')
  end
end

class Card
  SUITS = ["♥", "♠", "♦", "♣"]
  VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "#{display_value} of #{display_suit}"
  end

  def display_lines
    [
      '┌─────┐',
      "│#{@value.ljust(2)}   │",
      "│  #{@suit}  │",
      "│   #{@value.rjust(2)}│",
      '└─────┘'
    ]
  end

  def hidden_card_lines
    [
      '┌─────┐',
      '│?    │',
      '│  ?  │',
      '│    ?│',
      '└─────┘'
    ]
  end

  private

  def display_value
    case @value
    when 'A' then 'Ace'
    when 'K' then 'King'
    when 'Q' then 'Queen'
    when 'J' then 'Jack'
    else @value
    end
  end

  def display_suit
    case @suit
    when '♥' then 'Hearts'
    when '♠' then 'Spades'
    when '♣' then 'Clubs'
    when '♦' then 'Diamonds'
    else '?'
    end
  end
end

class Deck
  attr_reader :cards

  def initialize
    @cards = build_deck.shuffle
  end

  def deal_card
    @cards.pop
  end

  private

  def build_deck
    deck = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        deck << Card.new(suit, value)
      end
    end
    deck
  end
end

class Participant
  include Hand

  attr_reader :name

  def initialize(name)
    @name = name
    @cards = []
  end
end

class Player < Participant
  def hit_or_stay
    loop do
      Message.prompt('hit_or_stay')
      decision = gets.chomp.strip.downcase
      return decision if ['h', 'hit', 's', 'stay'].include?(decision)
      puts Message['invalid_hit_or_stay']
    end
  end

  def wants_to_hit?
    decision = hit_or_stay
    ['h', 'hit'].include?(decision)
  end
end

class Dealer < Participant
  DEALER_STAYS_DEFAULT = 17

  def initialize
    super("Dealer")
  end

  def should_hit?(goal_score, dealer_stays)
    total(goal_score) < dealer_stays
  end

  def show_initial_cards
    first_card = cards.first
    [first_card.to_s, "unknown card"]
  end
end

class Score
  attr_reader :player_wins, :dealer_wins

  def initialize(player_name)
    @player_wins = 0
    @dealer_wins = 0
    @player_name = player_name
  end

  def update(result)
    case result
    when :player, :dealer_busted
      @player_wins += 1
    when :dealer, :player_busted
      @dealer_wins += 1
    end
  end

  def match_over?
    @player_wins == TwentyOne::ROUNDS_TO_WIN ||
      @dealer_wins == TwentyOne::ROUNDS_TO_WIN
  end

  def display
    Message.starred('separator')
    puts Message['scoreboard', @player_wins, @dealer_wins]
    Message.starred('separator')
  end

  def reset
    @player_wins = 0
    @dealer_wins = 0
  end
end

class TwentyOne
  include Displayable
  include CurrentMatchDisplay

  ROUNDS_TO_WIN = 5
  GOAL_SCORE_DEFAULT = 21

  def initialize
    @player_name = ask_name
    @player = Player.new(@player_name)
    @dealer = Dealer.new
    @goal_score = GOAL_SCORE_DEFAULT
    @dealer_stays = Dealer::DEALER_STAYS_DEFAULT
    @score = Score.new(@player_name)
    @grand_winners = {
      player: 0,
      dealer: 0,
      player_streak: 0,
      dealer_streak: 0
    }
  end

  def start
    Utilities.clear_screen
    Message.starred('welcome', @player_name)
    ask_display_rules

    loop do
      setup_match
      play_match
      display_grand_winner_info
      break unless play_again?
    end
  end

  private

  def ask_name
    Utilities.clear_screen
    loop do
      Message.prompt('enter_name')
      name = gets.chomp.strip.split.map(&:capitalize).join(' ')
      Utilities.clear_screen
      break name unless name.empty?
      Message.prompt('invalid_name')
    end
  end

  def ask_display_rules
    puts Message['small_rules']
    input = gets.chomp
    Utilities.clear_screen
    display_full_rules if input.downcase == 'rules'
  end

  def ask_start
    Message.prompt('game_start')
    loop do
      choice = gets.chomp.strip.downcase
      if ['no', 'n'].include?(choice)
        display_farewell
      elsif ['yes', 'y'].include?(choice)
        Utilities.clear_screen
        return true
      else
        puts Message['invalid_choice']
      end
    end
  end

  def setup_match
    update_goal_score
    @round = 0
    @score.reset
  end

  def play_match
    until @score.match_over?
      play_round
      break unless continue_round?
    end
  end

  def play_round
    display_game_state
    @round += 1
    display_round_info

    @deck = Deck.new
    reset_hands
    deal_initial_cards
    display_initial_cards

    player_turn
    return if @player.busted?(@goal_score)

    dealer_turn

    determine_winner
    display_final_results
  end

  def reset_hands
    @player.reset_hand
    @dealer.reset_hand
  end

  def deal_initial_cards
    2.times do
      @player.add_card(@deck.deal_card)
      @dealer.add_card(@deck.deal_card)
    end
  end

  def player_turn
    loop do
      break unless @player.wants_to_hit?

      puts Message['you_hit']
      @player.add_card(@deck.deal_card)
      puts Message['updated_player', @player.show_cards,
                   @player.total(@goal_score)]
      display_cards_visually(@player.cards)

      break if @player.busted?(@goal_score)
    end

    return if @player.busted?(@goal_score)
    puts Message['you_stayed', @player.total(@goal_score)]
  end

  def dealer_turn
    return if @player.busted?(@goal_score)

    puts Message['dealer_turn']
    Utilities.add_suspense

    while @dealer.should_hit?(@goal_score, @dealer_stays)
      puts Message['dealer_hit']
      @dealer.add_card(@deck.deal_card)
      puts Message['updated_dealer_cards', @dealer.show_cards]
      puts Message['dealer_total', @dealer.total(@goal_score)]
    end

    return if @dealer.busted?(@goal_score)
    puts Message['dealer_stay', @dealer.total(@goal_score)]
  end

  def determine_winner
    player_total = @player.total(@goal_score)
    dealer_total = @dealer.total(@goal_score)

    result = detect_result(dealer_total, player_total)
    @score.update(result)
    display_round_result(result)
  end

  def detect_result(dealer_total, player_total)
    if @player.busted?(@goal_score)
      :player_busted
    elsif @dealer.busted?(@goal_score)
      :dealer_busted
    elsif dealer_total == player_total
      :tie
    else
      dealer_total > player_total ? :dealer : :player
    end
  end

  def continue_round?
    return false if @score.match_over?

    loop do
      Message.prompt('continue')
      choice = gets.chomp.strip.downcase
      if choice.empty?
        return true
      elsif choice == 'quit' || choice == 'q'
        display_farewell
      else
        Utilities.clear_screen
        puts Message['invalid_choice']
      end
    end
  end

  def update_grand_winners
    if @score.player_wins == ROUNDS_TO_WIN
      @grand_winners[:player] += 1
      @grand_winners[:player_streak] += 1
      @grand_winners[:dealer_streak] = 0
    elsif @score.dealer_wins == ROUNDS_TO_WIN
      @grand_winners[:dealer] += 1
      @grand_winners[:dealer_streak] += 1
      @grand_winners[:player_streak] = 0
    end
  end

  def update_goal_score
    Utilities.clear_screen
    puts Message['change_goal_score']
    return unless ask_choice

    @goal_score = ask_goal_score
    @dealer_stays = @goal_score - 4
  end

  def ask_goal_score
    loop do
      Utilities.clear_screen
      Message.prompt('enter_goal_score')
      choice = gets.chomp.to_i
      return choice if [21, 31, 41, 51].include?(choice)
    end
  end

  def ask_choice
    loop do
      choice = gets.chomp.strip.downcase
      if ['no', 'n'].include?(choice)
        return false
      elsif ['yes', 'y'].include?(choice)
        return true
      else
        puts Message['invalid_choice']
      end
    end
  end

  def play_again?
    Message.prompt('play_again')
    choice = ask_choice
    display_farewell unless choice
    choice
  end
end

TwentyOne.new.start
