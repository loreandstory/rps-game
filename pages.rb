module Page
  class Pages

    def new_page
      system('clear')
    end

    def title
      puts "| #{$game_type} |"
    end

    def prompt(message)
      print "\n=> #{message}: "
    end
  end

  class PreGame < Pages
  end

  class ChooseMoves < Pages
  end

  class Results < Pages
  end

  class Statistics < Pages
  end
end
