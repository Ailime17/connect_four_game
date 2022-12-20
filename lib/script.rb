# class for the whole 'connect four' game
class ConnectFour
  def initialize
    @grid = make_grid
    @grid_for_display = grid_for_display
    @player1 = "\u26BD" # football emoji
    @player2 = "\u26BE" # baseball emoji
    @winning_positions = winning_positions
    @player1_positions = []
    @player2_positions = []
    @position = []
    @winner = false
    @grid_empty = false
  end

  # creates 6x7 grid for the game
  def make_grid
    grid = []
    0.upto(5) do |n|
      0.upto(6) do |num|
        grid << [n, num]
      end
    end
    grid
  end

  # visual grid that will be displayed in the console
  def grid_for_display
    %{
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
      }
  end

  def winning_positions
    # each of the variable's subarrays contain 3 places on the grid that grant victory for the player
    horizontal_positions = [[[0,1],[0,2],[0,3]], [[0,-1],[0,-2],[0,-3]], [[0,1],[0,-1],[0,-2]], [[0,1],[0,2],[0,-1]]]
    vertical_positions = [[[1,0],[2,0],[3,0]], [[-1,0],[-2,0],[-3,0]], [[1,0],[2,0],[-1,0]], [[1,0],[-1,0],[-2,0]]]
    diagonal_left_positions = [[[1,-1],[2,-2],[3,-3]], [[2,-2],[1,-1],[-1,1]], [[1,-1],[-1,1],[-2,2]], [[-1,1],[-2,2],[-3,3]]]
    diagonal_right_positions = [[[1,1],[2,2],[3,3]], [[-1,-1],[-2,-2],[-3,-3]], [[-1,-1],[1,1],[2,2]], [[-2,-2],[-1,-1],[1,1]]]
    horizontal_positions + vertical_positions + diagonal_left_positions + diagonal_right_positions
  end

  def play_game
    introduction
    puts @grid_for_display
    player = 1
    loop do
      break if @winner || @grid_empty

      case player
      when 1
        make_move(@player1)
        player = 2
      when 2
        make_move(@player2)
        player = 1
      end
    end
  end

  def introduction
    puts '**Welcome to the Connect Four game**'
    puts %(
      Rules: First player who fills 4 adjacent positions in diagonal, vertical, 
      or horizontal direction - wins!
        )
  end

  # gets player's next move & updates the grid accordingly &
  # ends game if it was a winning move or if all grid places are taken
  def make_move(player)
    position = verify_position(player)
    update_player_positions(player, position)
    @grid.delete(position)
    display_grid(player, position)
    announce_game_over(player) if winner?(player) || game_over?
  end

  def verify_position(player)
    puts "#{player == @player1 ? 'Player1' : 'Player2'}: Choose a column to place your symbol in. (Columns 0 through 6)"
    column = gets.strip
    until (0..6).include?(column.to_i) && column_available?(column.to_i)
      puts 'Invalid column. Choose again'
      column = gets.strip
    end
    @position
  end

  def column_available?(column)
    @position = []
    @grid.each do |grid_position|
      if grid_position[1] == column
        @position = grid_position
        break
      end
    end
    return true unless @position.empty?
  end

  # assigns chosen position in the grid to the player
  def update_player_positions(player, position)
    if player == @player1
      @player1_positions << position
    else
      @player2_positions << position
    end
  end

  # updates and displays updated grid in the console
  def display_grid(player, position)
    position_to_swap = @grid_for_display.index(position.join)
    @grid_for_display[position_to_swap + 1] = ''
    @grid_for_display[position_to_swap] = player
    puts @grid_for_display
  end

  # checks if player has taken winning positions in the grid
  def winner?(player)
    player_positions = (player == @player1 ? @player1_positions : @player2_positions)
    @winning_positions.each do |winning_set|
      player_positions.each do |player_position|
        taken_places = 0
        winning_set.each do |place|
          hypothetical_position = [] << player_position[0] << player_position[1]
          hypothetical_position[0] += place[0]
          hypothetical_position[1] += place[1]
          taken_places += 1 if player_positions.include?(hypothetical_position)
          if taken_places == 3
            @winner = true
            return true
          end
        end
      end
    end
    false
  end

  def game_over?
    if @grid.empty?
      @grid_empty = true
      return true
    end
  end

  def announce_game_over(player)
    if @winner
      player = (player == @player1 ? 'Player1' : 'Player2')
      puts "Congratulations! #{player} wins. Game over"
    else
      puts "It's a tie! Game over"
    end
  end
end
game = ConnectFour.new
# game.play_game
