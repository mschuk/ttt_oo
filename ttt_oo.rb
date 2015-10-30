class Board

  attr_accessor :positions

  WINNING_COMBOS = [[1,2,3],[4,5,6],[7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

  def initialize
    @positions = {}
    (1..9).each {|num| self.positions[num] = ' '}
  end

  def display_positions
    system 'clear'
    puts "  #{positions[1]}  | #{positions[2]}  | #{positions[3]}   "
    puts "----------------"
    puts "  #{positions[4]}  | #{positions[5]}  | #{positions[6]}   "
    puts "----------------"
    puts "  #{positions[7]}  | #{positions[8]}  | #{positions[9]}   "
  end

  def clear_board
    (1..9).each {|num| self.positions[num] = ' '}
  end

  def available_moves
    positions.select { |_, mark| mark == ' '}
  end

  def output_available_moves(num)
    until available_moves.include?(num)
      puts 'That number is not available.  Pick a number on the board that is empty.'
      num = gets.chomp.to_i
    end
  end

  def two_in_a_row
    WINNING_COMBOS.each do |set|
      board_array = positions.values_at(set[0], set[1], set[2])
      if board_array.count('x') == 2 && board_array.count(' ') == 1
        empty_match = board_array.index(' ')
        return set[empty_match]
      elsif board_array.count('o') == 2 && board_array.count(' ') == 1
        empty_match = board_array.index(' ')
        return set[empty_match]
      end
    end
    nil
  end

  def available_moves_empty?
    available_moves.empty?
  end

  def check_winner
    WINNING_COMBOS.each do |set|
      if positions.values_at(set[0], set[1], set[2]).count('x') == 3
        return 'player'
      elsif positions.values_at(set[0], set[1], set[2]).count('o') == 3
        return 'computer'
      end
    end
    nil
  end

end

class Game

  attr_accessor :board

  def initialize
    self.board = Board.new
  end

  def player_move(num)
    board.positions[num] = 'x'
  end

  def computer_move
    best_move = board.two_in_a_row
    if board.positions[5] == ' '
      board.positions[5] = 'o'
    elsif best_move
      board.positions[best_move] = 'o'
    else
      possible_moves = board.available_moves
      board.positions[possible_moves.keys.sample] = 'o'
    end
  end

  def winner_output(winner)
    if winner == 'player'
      puts 'You won!'
    elsif winner == 'computer'
      puts 'The Computer won!'
    else
      puts 'The board is full.'
    end
  end


  def move(num)
    player_move(num)
    winner = board.check_winner
    board.display_positions
    unless winner
      computer_move
      winner = board.check_winner
    end
    winner
  end


  def run
    loop do
      board.clear_board
      board.display_positions
      puts "Let's play!"
      begin
        puts 'Pick a number 1-9 to mark the board'
        num = gets.chomp.to_i
        board.output_available_moves(num)
        winner = move(num)
        board_full = board.available_moves_empty?
        board.display_positions
      end until winner || board_full

      winner_output(winner)

      puts 'Enter y if you would like to play again'
      play_again = gets.chomp

      break if play_again.downcase != 'y'
    end
  end
end

Game.new.run