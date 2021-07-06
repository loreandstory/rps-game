class Moves
  attr_reader :move

  RULES = {
            'rock'     => ['scissors', 'lizard'],
            'paper'    => ['rock', 'spock'],
            'scissors' => ['paper', 'lizard'],
            'lizard'   => ['paper', 'spock'],
            'spock'    => ['scissors', 'rock']
          }.freeze

  def >(other)
    RULES[self.move].include? other.move
  end

  def <(other)
    RULES[other.move].include? self.move
  end

  def to_s
    move
  end
end

class Rock < Moves
  def initialize() @move = 'rock'; end
end

class Paper < Moves
  def initialize() @move = 'paper'; end
end

class Scissors < Moves
  def initialize() @move = 'scissors'; end
end

class Lizard < Moves
  def initialize() @move = 'lizard'; end
end

class Spock < Moves
  def initialize() @move = 'spock'; end
end
