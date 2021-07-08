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

    attr_accessor :header, :request, :options_header, :options, :prompt_text, :possible_choices

    def game_name
      $game_type == 'rps' ? 'Rock Paper Scissors' : 'Lizard Spock'
    end

    def moves
      Players::POSSIBLE_MOVES[$game_type]
    end

    def new_page(required_info = nil)
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
      self.header = "Game Types"
      self.request = "Select which version of #{game_name} to play..."
      self.options_header = "Types"

      self.options = [
                       ['rps', 'Rock Paper Scissors'],
                       ['ls',  'Lizard Spock']
                     ]

      self.prompt_text = "Enter type to play"
      self.possible_choices = ['rps', 'ls']

      new_page(player_name)
    end

    def new_page(player_name)
      super
      print "\nHello #{player_name}!"
      print "\n      #{'-' * player_name.length}\n"
    end
  end

  class ChooseMove < Pages
    def initialize(computer_name)
      self.header = "Choose Move"
      self.request = "Make your move from the list below..."

      self.options_header = "Moves"
      self.options = moves.keys

      self.prompt_text = "Enter type to play"
      self.possible_choices = options

      new_page(computer_name)
    end

    private

    def new_page(computer_name)
      super
      print "\nYou chose to play --> #{game_name}."
      print "\n                      #{'-' * game_name.length}\n"

      print "\nYou are playing against: #{computer_name}"
      print "\n                       #{'-' * computer_name.length}\n"
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

      self.prompt_text = "Enter type to play"
      self.possible_choices = options

      new_page(game_history)
    end

    private

    def dramatic_print(text, text_to_slow, time)
      subtext = text.split(text_to_slow)
      i = 0

      loop do
        print subtext[i]
        break if i == subtext.size - 1

        text_to_slow.split('') { |char| sleep(time); print char }
        i += 1
      end
    end

    def new_page(game_history)
      super
      winners, player_info, computer_info = game_history

      dramatic_print("\nShow in 1...2...3...SHOW!\n", "...", 0.33)
    end
  end

  class InfoAndContinue
  end
end
