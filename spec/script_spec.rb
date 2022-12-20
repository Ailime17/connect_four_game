# frozen_string_literal: true

require './lib/script'

describe ConnectFour do
  let(:player1) { subject.instance_variable_get(:@player1) }
  let(:player2) { subject.instance_variable_get(:@player2) }

  describe '#make_grid' do
    it 'creates a 6x7 grid for the game' do
      expect(subject.make_grid.length).to eq(42)
    end
  end

  describe '#winning_positions' do
    it 'creates an array of all winning combinations in the grid' do
      expect(subject.winning_positions.length).to eq(16)
    end
  end

  describe '#initialize' do
    it 'initializes @grid instance variable' do
      grid = subject.instance_variable_get(:@grid)
      expect(grid).to be_truthy
    end
    it 'initializes @player1 & @player2 instance variables' do
      expect(player1).to be_truthy
      expect(player2).to be_truthy
    end
    it 'initializes @winning_positions instance variable' do
      winning_positions = subject.instance_variable_get(:@winning_positions)
      expect(winning_positions).to be_truthy
    end
    it 'initializes @grid_for_display instance variable' do
      grid_for_display = subject.instance_variable_get(:@grid_for_display)
      expect(grid_for_display).to eq(%{
      | 50 | 51 | 52 | 53 | 54 | 55 | 56 |
      ------------------------------------
      | 40 | 41 | 42 | 43 | 44 | 45 | 46 |
      ------------------------------------
      | 30 | 31 | 32 | 33 | 34 | 35 | 36 |
      ------------------------------------
      | 20 | 21 | 22 | 23 | 24 | 25 | 26 |
      ------------------------------------
      | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
      ------------------------------------
      | 00 | 01 | 02 | 03 | 04 | 05 | 06 |
         0    1    2    3    4    5    6
      })
    end
  end

  describe '#make_move(player)' do
    before { spec_helper_suppress_output }
    context 'after player chooses a column' do
      it 'fills the available position in the grid' do
        grid = subject.instance_variable_get(:@grid)
        allow(subject).to receive(:verify_position).with(player1).and_return([0, 6])
        subject.make_move(player1)
        expect(grid.length).to eq(41)
      end
    end
  end

  describe '#update_player_positions(player, position)' do
    it 'assigns chosen position in the grid to the player' do
      expect(subject.update_player_positions(player1, [0,0])).to eq([[0,0]])
    end
  end

  describe '#verify_position(player)' do
    before { spec_helper_suppress_output }
    context 'when player inputs valid column number' do
      it 'stops loop and does not display error message' do
        allow(subject).to receive(:gets).and_return('6')
        subject.verify_position(player1)
        expect(subject).not_to receive(:puts).with('Invalid column. Choose again')
      end
    end
  end

  describe '#column_available?(column)' do
    context 'when player inputs an available column number' do
      it 'returns true' do
        expect(subject.column_available?(6)).to be true
      end

      it 'sets @position to the available position in the column' do
        subject.column_available?(6)
        position = subject.instance_variable_get(:@position)
        expect(position).to_not be_empty
      end
    end
  end

  describe '#winner?(player)' do
    it 'checks if player has taken winning positions in the grid' do
      subject.instance_variable_set(:@player1_positions, [[0,6],[1,6],[2,6],[3,6]])
      expect(subject.winner?(player1)).to be true
    end
  end

  describe '#announce_game_over' do
    context 'when there is a winner' do
      it 'announces winner and end of game' do
        subject.instance_variable_set(:@winner, true)
        expect(subject).to receive(:puts).with('Congratulations! Player1 wins. Game over')
        subject.announce_game_over(player1)
      end
    end
    context 'when it is a draw' do
      it 'announces end of game' do
        subject.instance_variable_set(:@winner, false)
        expect(subject).to receive(:puts).with("It's a tie! Game over")
        subject.announce_game_over(player1)
      end
    end
  end

  describe '#game_over?' do
    context 'when all positions in the grid are taken by players' do
      it 'returns true' do
        subject.instance_variable_set(:@grid, [])
        expect(subject).to be_game_over
      end
    end
  end

  describe '#play_game' do
    it "calls #introduction to display its' messages" do
      subject.instance_variable_set(:@winner, true)
      allow(subject).to receive(:introduction)
      expect(subject).to receive(:introduction)
      subject.play_game
    end

    before { spec_helper_suppress_output }
    it 'calls #make_move in a loop until one of the players won or all places were taken' do
      # subject.instance_variable_set(:@grid_empty, true)
      subject.instance_variable_set(:@winner, true)
      allow(subject).to receive(:make_move).with(player1)
      allow(subject).to receive(:make_move).with(player2)
      expect(subject).not_to receive(:make_move).with(player1)
      expect(subject).not_to receive(:make_move).with(player2)
      subject.play_game
    end
  end

  describe '#introduction' do
    it 'displays a welcome message and rules' do
      expect(subject).to receive(:puts).with('**Welcome to the Connect Four game**')
      expect(subject).to receive(:puts).with(%(
      Rules: First player who fills 4 adjacent positions in diagonal, vertical, 
      or horizontal direction - wins!
        ))
      subject.introduction
    end
  end

  describe '#display_grid(player, position)' do
    it 'updates & displays the current state of the grid' do
      expect(subject).to receive(:puts).with(%{
      | 50 | 51 | 52 | 53 | 54 | 55 | 56 |
      ------------------------------------
      | 40 | 41 | 42 | 43 | 44 | 45 | 46 |
      ------------------------------------
      | 30 | 31 | 32 | 33 | 34 | 35 | 36 |
      ------------------------------------
      | 20 | 21 | 22 | 23 | 24 | 25 | 26 |
      ------------------------------------
      | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
      ------------------------------------
      | #{player1} | 01 | 02 | 03 | 04 | 05 | 06 |
         0    1    2    3    4    5    6
      })
      subject.display_grid(player1, [0,0])
    end
  end
end
