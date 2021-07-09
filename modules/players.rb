class Players
  attr_reader :name, :move

  POSSIBLE_MOVES = {
    'rps' => {
      'rock' => Rock.new,
      'paper' => Paper.new,
      'scissors' => Scissors.new
    },

    'ls' => {
      'rock' => Rock.new,
      'paper' => Paper.new,
      'scissors' => Scissors.new,
      'lizard' => Lizard.new,
      'spock' => Spock.new
    }
  }.freeze

  def moves
    POSSIBLE_MOVES[$game_version]
  end

  def to_s
    name
  end

  def move=(chosen_move)
    @move = moves[chosen_move]
  end
end

class Human < Players
  def initialize(n)
    self.name = n
  end

  private

  attr_writer :name
end

class Computer < Players
  def preference(preferred_choice, tries)
    move_name = nil
    i = 0

    while move_name != preferred_choice && i < tries
      move_name = moves.keys.sample
      i += 1
    end

    move_name
  end
end

class Bot < Computer
  def initialize() @name = 'Bot'; end

  def personality
    moves.keys.sample
  end
end

class R2D2 < Computer
  def initialize() @name = 'R2D2'; end

  def personality
    if $game_version == 'rps'
      preference('rock', 3)
    else
      preference(['rock', 'lizard', 'lizard'].sample, 2)
    end
  end
end

class C3PO < Computer
  def initialize() @name = 'C3PO'; end

  def personality
    if $game_version == 'rps'
      preference('paper', 2)
    else
      preference('spock', 3)
    end
  end
end

class BB8 < Computer
  def initialize() @name = 'BB8'; end

  def personality
    if $game_version == 'rps'
      preference(['rock', 'paper'].sample, 2)
    else
      preference(['rock', 'paper', 'lizard'].sample, 2)
    end
  end
end

class Walle < Computer
  def initialize() @name = 'Walle'; end

  def personality
    if $game_version == 'rps'
      'scissors'
    else
      ['scissors', 'spock'].sample
    end
  end
end

class Sonny < Computer
  def initialize() @name = 'Sonny'; end

  def personality
    if $game_version == 'rps'
      'paper'
    else
      ['paper', 'spock', 'spock'].sample
    end
  end
end

class Hal < Computer
  def initialize() @name = 'Hal'; end

  def personality
    if $game_version == 'rps'
      preference('rock', 3)
    else
      'spock'
    end
  end
end
