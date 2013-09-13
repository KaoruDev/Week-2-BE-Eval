require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'pry'
require_relative '../tennis'

describe Tennis::Game do
  let(:game) { Tennis::Game.new }

  describe '.initialize' do
    it 'creates two players' do
      expect(game.player1).to be_a(Tennis::Player)
      expect(game.player2).to be_a(Tennis::Player)
    end

    it 'sets the opponent for each player' do
      expect(game.player1.opponent).to eq(game.player2)
      expect(game.player2.opponent).to eq(game.player1)
    end
  end

  describe '#wins_ball' do
    it 'increments the points of the winning player' do
      game.wins_ball(1)

      expect(game.player1.points).to eq(1)
    end
  end
end

describe Tennis::Player do
  let(:player) do
    player = Tennis::Player.new
    player.opponent = Tennis::Player.new
    player.opponent.opponent = player

    return player
  end

  describe '.initialize' do
    it 'sets the points to 0' do
      expect(player.points).to eq(0)
    end 
  end

  describe '#record_won_ball!' do
    it 'increments the points' do
      player.record_won_ball!

      expect(player.points).to eq(1)
    end
  end

  describe '#score' do
    context 'when points is 0' do
      it 'returns love' do
        expect(player.score).to eq('love')
      end
    end
    
    context 'when points is 1' do
      it 'returns fifteen' do
        player.points = 1

        expect(player.score).to eq('fifteen')
      end 
    end
    
    context 'when points is 2' do
      it 'returns thirty'  do
        player.points = 2
        expect(player.score).to eq('thirty')
      end
    end
    
    context 'when points is 3' do
      it 'returns forty' do
        player.points = 3
        expect(player.score).to eq('forty')
      end
    end

    context 'when players are tied and have more than 3 points' do
      it 'returns deuce' do
        player.points = 3
        player.opponent.points = 3

        expect(player.score).to eq("deuce")
      end
    end

    context 'when player leads by one point and both player has more than 3 points' do
      it 'returns advantage' do
        player.points = 4
        player.opponent.points = 3


        expect(player.score).to eq("advantage")
      end
    end

    context 'when player leads by 2 points and has more than 3 points' do
      it 'returns win' do
        player.points = 5

        expect(player.score).to eq("win")
      end
    end

    context 'record games won of player' do
      it 'returns games won' do
        player.points = 5
        player.score

        expect(player.games_won).to eq(1)
      end
    end

    context 'resets points if player wins a game' do
      it 'returns games won' do
        player.opponent.opponent = player
        3.times { player.record_won_ball!}
        4.times { player.opponent.record_won_ball! }
        5.times { player.record_won_ball!}

        expect(player.games_won).to eq(1)
      end

      it 'returns player score for new game' do
        3.times { player.record_won_ball!}
        4.times { player.opponent.record_won_ball! }
        5.times { player.record_won_ball!}

        expect(player.score).to eq("thirty")
      end
    end

    context 'player wins set when player wins 4 games and is ahead by 2 games' do
      it 'returns set won by player' do
        player.games_won = 4
        player.opponent.games_won = 3
        4.times { player.record_won_ball! }

        expect(player.sets_won).to eq(1)
      end
    end

    context "player wins a set 7-6" do
      it 'returns a set win by player if tie-break occurs' do
        player.games_won = 6
        player.opponent.games_won = 6
        4.times { player.record_won_ball! }

        expect(player.sets_won).to eq(1)
      end

      it 'resets games and points to zero if the set is won' do
        player.games_won = 6
        player.opponent.games_won = 6
        4.times { player.record_won_ball! }

        expect(player.games_won).to eq(0)
        expect(player.points).to eq(0)
      end
    end
  end
end # end of Tennis:Player testing.

