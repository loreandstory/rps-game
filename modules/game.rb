class Game
  attr_reader :score, :history, :stats, :count

  def initialize
    @score   = { wins: 0,     loses: 0,   ties: 0 }
    @history = { winners: [], player: [], computer: [] }
    @count = 0
  end

  def update(player, computer)
    winner = if player.move > computer.move
               score[:wins] += 1
               player.name
             elsif player.move < computer.move
               score[:loses] += 1
               computer.name
             else
               score[:ties] += 1
               'tie'
             end

    history[:winners]  << winner
    history[:player]   << [player.name, player.move.to_s]
    history[:computer] << [computer.name, computer.move.to_s]

    @count += 1
  end

  def update_stats
    winners, player_hist, computer_hist = history.values
    player_name = player_hist.first.first

    base_stats = moves.each_with_object({}) do |(move, _), obj|
      obj[move] = 0
    end

    base_stats['total'] = 0

    game_percentages = calc_game_percentages(winners, player_name)
    player_stats     = tally_player_stats(player_hist, base_stats)
    computer_stats   = tally_player_stats(computer_hist, base_stats)

    @stats = {
      'game_percentages' => game_percentages,
      'player_stats' => player_stats,
      'computer_stats' => computer_stats
    }
  end

  private

  def moves
    Players::POSSIBLE_MOVES[$game_version]
  end

  def calc_game_percentages(winners, player_name)
    player_wins = winners.select { |winner| winner == player_name }
    ties = winners.select { |winner| winner == 'tie' }

    win_percent  = (100 * player_wins.size) / winners.size
    tie_percent  = (100 * ties.size) / winners.size
    lose_percent = 100 - win_percent - tie_percent

    { 'won' => win_percent, 'lost' => lose_percent, 'tied' => tie_percent }
  end

  def tally_player_stats(hist, base_stats)
    hist.each_with_object({}) do |(player, move), obj|
      obj[player] = base_stats.clone unless obj.key? player
      obj[player][move]    += 1
      obj[player]['total'] += 1
    end
  end
end
