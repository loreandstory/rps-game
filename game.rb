class Game
  attr_reader :type, :score, :history, :stats

  GAME_TYPES = ['rps', 'ls'].freeze

  def initialize
    @winner = ""
    @score = { wins: 0, loses: 0, ties: 0 }
    @history = { winners: [], player: [], computer: [] }
    self.type=(nil)
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
  end

  def winner
    history[:winners].last
  end

  def calc_game_percentages(winners, player_name)
    player_wins = winners.select { |winner| winner == player_name }
    ties = winners.select { |winner| winner == 'tie' }

    win_percent = (100 * player_wins.size) / winners.size
    tie_percent = (100 * ties.size) / winners.size
    lose_percent = 100 - win_percent - tie_percent

    { 'wins' => win_percent, 'loses' => lose_percent, 'ties' => tie_percent }
  end

  def tally_player_stats(hist)
    player_stats = {}
    base_stats = if type == 'rps'
                   { 'total' => 0, 'rock' => 0, 'paper' => 0, 'scissors' => 0 }
                 else
                   {
                     'total' => 0,    'rock' => 0,   'paper' => 0,
                     'scissors' => 0, 'lizard' => 0, 'spock' => 0
                   }
                 end

    hist.size.times do |i|
      name = hist[i].first
      move = hist[i].last

      player_stats[name] = base_stats.clone unless player_stats.has_key? name

      player_stats[name][move] += 1
      player_stats[name]['total'] += 1
    end

    player_stats
  end

  def tally_stats
    @stats = {}
    winners, player_hist, computer_hist = history.values
    player_name = player_hist.first.first

    game_percentages =  calc_game_percentages(winners, player_name)
    player_stats = tally_player_stats(player_hist)
    computer_stats = tally_player_stats(computer_hist)

    @stats = {
               'game_percentages' => game_percentages,
               'player_stats'     => player_stats,
               'computer_stats'   => computer_stats
             }
  end

  def print_score
    player = history[:player].last.first

    puts "#{player}, the current score is..."
    print "\n  |Score|"
    print "\n    wins  => #{score[:wins]}"
    print "\n    loses => #{score[:loses]}"
    print "\n    ties  => #{score[:ties]}"
  end

  private

  attr_writer :stats

  def prompt(message)
    print "\n=> " + message + ": "
  end

  def type=(n)
    puts "Game Options..."
    print "\n  |Input|"
    print "\n    rps => Rock Paper Scissors"
    print "\n    ls  => Lizard Spock\n"

    prompt("Choose your game type")
    @type = gets.chomp

    return if GAME_TYPES.include? type

    puts "Please enter a valid game type..."
    self.type=(n)
  end
end
