class Croupier::Game::Steps::Betting::Player

  def initialize(betting_state, index)
    @betting_state = betting_state
    @player = betting_state.players[index]
    @index = index
  end

  def take_turn
    if @player.allin? or not @player.active?
      return
    end

    bet = @player.bet_request betting_state_for_player

    if allin_bet? bet
      handle_allin
    elsif raise_bet? bet
      handle_raise bet
    elsif call_bet? bet
      handle_call
    elsif check_bet?
      handle_check
    else
      handle_fold
    end
  end

  def betting_state_for_player
    @betting_state.data.tap do |data|
      data[:players].each_with_index do |player, index|
        player.delete(:hole_cards) unless index == @index
      end
    end
  end

  def active?
    @player.active?
  end

  def allin?
    @player.allin?
  end

  def total_bet
    @player.total_bet
  end

  private

  def allin_bet?(bet)
    bet > 0 && bet >= @player.stack
  end

  def handle_allin
    handle_bet @player.stack, :allin
  end

  def raise_bet?(bet)
    bet > 0 && raise_by(bet) >= @betting_state.minimum_raise && !allin_bet?(bet)
  end

  def handle_raise(bet)
    handle_bet bet, :raise
  end

  def check_bet?
    to_call == 0
  end

  def handle_check
    handle_bet 0, :check
  end

  def call_bet?(bet)
    @player.total_bet + bet >= @betting_state.game_state.current_buy_in && !(raise_bet?(bet) || allin_bet?(bet) || check_bet?)
  end

  def handle_call
    handle_bet to_call, :call
  end

  def to_call
    @betting_state.game_state.current_buy_in - @player.total_bet
  end

  def handle_fold
    handle_bet 0, :fold
    @player.fold
  end

  def handle_bet(bet, type)
    update_minimum_raise bet
    @betting_state.transfer_bet @player, bet, type
  end

  def update_minimum_raise(bet)
    @betting_state.minimum_raise = [@betting_state.minimum_raise, raise_by(bet)].max
  end

  def raise_by(bet)
    @player.total_bet + bet - @betting_state.game_state.current_buy_in
  end
end