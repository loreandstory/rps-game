module Page
  class Pages
    def interface_with_user
      print_options
      prompt_user

      user_input = gets.chomp
      return user_input if valid_input?(user_input)

      print "\nI couldn't understand your input. Please try again...\n\n"
      interface_with_user
    end

    private

    attr_accessor :header, :request, :options_header, :options, :prompt_text,
                  :possible_choices

    def game_name
      $game_version == 'rps' ? 'Rock Paper Scissors' : 'Lizard Spock'
    end

    def moves
      Players::POSSIBLE_MOVES[$game_version]
    end

    def timed_print(text, text_to_slow, time)
      subtext = text.split(text_to_slow)
      i = 0

      loop do
        print subtext[i]
        break if i == subtext.size - 1

        text_to_slow.split('') do |char|
          sleep(time)
          print char
        end

        i += 1
      end
    end

    def new_page(_required_info = nil, _games_count = nil)
      system('clear')              # New Page
      puts "{ #{game_name} }"      # Title
      print "\n\n## #{header}\n"   # Header
    end

    def print_options
      print "\n#{request}\n"
      print "\n  |#{options_header}|\n"

      options.each do |(option, descr)|
        puts "    #{option} => #{descr}"
      end
    end

    def prompt_user
      print "\n=> #{prompt_text}: "
    end

    def valid_input?(input)
      possible_choices.include? input
    end
  end

  class PlayerName < Pages
    def initialize
      self.header = "Welcome to #{game_name}!"
      self.prompt_text = "Please choose your player name"
      new_page
    end

    def valid_input?(input)
      !input.empty?
    end

    def interface_with_user
      prompt_user

      user_input = gets.chomp
      return user_input if valid_input?(user_input)

      print "\nI couldn't understand your input. Please try again...\n\n"
      interface_with_user
    end
  end

  class GameType < Pages
    def initialize(player_name)
      self.header = "Game Version"
      self.request = "Select which version of #{game_name} to play..."
      self.options_header = "Versions"

      self.options = [
        ['rps', 'Rock Paper Scissors'],
        ['ls',  'Lizard Spock']
      ]

      self.prompt_text = "Enter version to play"
      self.possible_choices = ['rps', 'ls']

      new_page(player_name)
    end

    def new_page(player_name)
      super
      dashes = '-' * player_name.length

      print "\nHello #{player_name}!"
      timed_print("\n      #{dashes}\n", dashes.to_s, 0.1)

      sleep(1)
    end
  end

  class ChooseMove < Pages
    def initialize(computer_name, games_count)
      self.header = "Choose Move"
      self.request = "Choose your move from the list below..."

      self.options_header = "Moves"
      self.options = moves.keys

      self.prompt_text = "Enter move to play"
      self.possible_choices = options

      new_page(computer_name, games_count)
    end

    private

    def new_page(computer_name, games_count)
      super
      dashes = '-' * game_name.length

      if games_count == 0
        timed_print("\nYou chose to play --> #{game_name}", " --> ", 0.33)
        timed_print("\n                      #{dashes}\n", dashes.to_s, 0.05)

        sleep(1)
      end

      dashes = '-' * computer_name.length

      timed_print("\nYou are playing against --> #{computer_name}", " --> ",
                  0.33)
      timed_print("\n                            #{dashes}\n", dashes.to_s, 0.1)

      sleep(1)
    end

    def print_options
      print "\n#{request}\n"
      print "\n  |#{options_header}|\n"

      options.each do |option|
        puts "    #{option}"
      end
    end
  end

  class Results < Pages
    def initialize(game_history)
      self.header = "Results"
      self.request = "..."

      self.options_header = "Moves"
      self.options = moves.keys

      self.prompt_text = "Enter version to play"
      self.possible_choices = options

      new_page(game_history)
    end

    private

    def new_page(game_history)
      super
      winners, player_info, computer_info = game_history.values

      winner = winners.last
      player_name, player_move = player_info.last
      computer_name, computer_move = computer_info.last

      sleep(0.5)
      print "\n#{player_name} and #{computer_name} have chosen their moves.\n"
      sleep(2)

      timed_print("\nShow in 1...2...3...SHOW!\n", "...", 0.33)

      print "\n   | #{player_name} chose --> #{player_move}"
      print "\n     #{' ' * player_name.length}           #{'-' * player_move.length}\n"

      print "\n   | #{computer_name} chose --> #{computer_move}"
      print "\n     #{' ' * computer_name.length}           #{'-' * computer_move.length}\n"

      sleep(2)
      timed_print("\nThe winner is --> { #{winner}! }", ' --> ', 0.33)

      dashes = '-' * winner.length
      timed_print("\n                    #{dashes}\n", dashes.to_s, 0.1)
    end
  end

  class ContinueAndStats < Pages
    def initialize(game)
      self.request = "\nReplay or see game history and statistics..."
      self.options_header = "Input Options"

      self.options = [
        ['yes', 'Play another round'],
        ['no',  'Exit game'],
        ['hist', 'View game history'],
        ['stats', 'See game stats']
      ]

      self.prompt_text = "Input"

      print_score(game)
    end

    def new_page(game, new_header, required_info = nil, games_count = nil)
      self.header = new_header
      super(required_info, games_count)

      if new_header == 'History'
        print_history(game.history)
      else
        print_stats(game.stats)
      end

      sleep(1)
      print_options
    end

    def interface_with_user(game)
      print_options
      user_input = nil

      match_continue = ['yes', 'YES', 'Y', 'y']
      match_exit = ['no', 'NO', 'N', 'n']
      match_history = ['hist', 'HIST', 'H', 'h', 'his', 'HIS']
      match_stats = ['stats', 'STATS', 'S', 's', 'stat', 'STAT']

      loop do
        prompt_user
        user_input = gets.chomp

        if match_history.include? user_input
          new_page(game, 'History')
        elsif match_stats.include? user_input
          new_page(game, 'Statistics')
        elsif (match_continue + match_exit).include? user_input
          break
        else
          print "\nI couldn't understand your input. Please try again...\n\n"
          next
        end
      end

      match_continue.include?(user_input) ? true : false
    end

    private

    def print_score(game)
      wins, loses, ties = game.score.values

      player_history = game.history[:player]
      player_name = player_history.last.first

      print "\n\n  |#{player_name}'s Score|"

      print "\n    wins:  #{wins}"
      print "\n    loses: #{loses}"
      print "\n    ties:  #{ties}\n"

      sleep(1)
    end

    def cell(text)
      text.ljust(20)
    end

    def print_history(history)
      winners, player_info, computer_info = history.values

      asize = winners.size
      print "\n#{cell('Name')}#{cell('Move')}#{cell('Winner')}"
      print "\n#{cell('----')}#{cell('----')}#{cell('------')}\n\n"

      asize.times do |i|
        print "#{cell(player_info[i][0])}#{cell(player_info[i][1])}#{cell(winners[i])}\n"
        print "#{cell(computer_info[i][0])}#{cell(computer_info[i][1])}#{cell('-' * winners[i].length)}\n\n"
      end

      print "\n#{'-' * 60}"
    end

    def print_each_players_stats(stats)
      total = stats['total']

      stats.each do |move, value|
        next if move == 'total'
        print "\n#{("#{move}:").ljust(10)}#{(100 * value) / total}%"
      end

      print "\n\ntotal played: #{total}\n"
    end

    def print_player_stats(title, player)
      print "\n\n\n[ #{title} ] #{'=' * 15}"

      player.each do |name, stats|
        print "\n\n## #{name}"
        print_each_players_stats(stats)
      end
    end

    def print_stats(stats)
      game_percentages, player_stats, computer_stats = stats.values

      game_percentages.each do |stat, value|
        print "\n#{("#{stat}:").ljust(6)}#{value}%"
      end

      print_player_stats('Player', player_stats)
      print_player_stats('Computer', computer_stats)

      print "\n\n#{'-' * 60}"
    end
  end
end
