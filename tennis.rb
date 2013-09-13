module Tennis
  class Game
    attr_accessor :player1, :player2

    def initialize
      @player1 = Player.new
      @player2 = Player.new

      @player1.opponent = @player2
      @player2.opponent = @player1
    end

    # Increase a player score. Expecting an integer.
    #
    # Returns nothing.
    def wins_ball(player_num)
      @player1.record_won_ball! if player_num == 1
      @player2.record_won_ball! if player_num == 2
    end
  end

  class Player
    attr_accessor :points, :opponent, :games_won, :sets_won

    def initialize
      @points = 0
      @games_won = 0
      @sets_won = 0
    end

    # Increments the score by 1.
    #
    # Returns the integer new score.
    def record_won_ball!
      @points += 1
      win?
    end

    # Returns the String score for the player.
    def score
      return 'love' if love?
      return "fifteen" if fifteen?
      return "thirty" if thirty?
      return "forty" if forty?
      return "deuce" if deuce?
      return "advantage" if advantage?
      return "win" if win?
    end

    private

    # Returns true if player's score is 0
    #
    def love?
      @points == 0
    end

    # Returns true if player's score is 1
    #
    def fifteen?
      @points == 1
    end

    # Returns true if player's score is 2
    #
    def thirty?
      @points == 2
    end

    # Returns true if player's score is 3 and not equal to player's points
    #
    def forty?
      @points == 3 && @points != @opponent.points
    end

    # Returns true if player's point == opponent's score and is > 3
    #
    def deuce?
      @points >= 3 && @points == @opponent.points
    end

    # Returns true is player points > 3 and is 1 more than oppponent's point
    #
    def advantage?
      @points == @opponent.points + 1
    end

    # Returns true if player points > 3 and 2 more than opponent's points.
    # Records a game win and resets player's and opponnent's score to 0
    #
    def win?
      if @points > @opponent.points + 1 && @points > 3
        @games_won += 1
        @points = 0
        @opponent.points = 0
        return true
      end
    end
  end
end