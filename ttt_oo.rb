require 'pry'


class TttBoard

  attr_accessor :board

  WINNING_COMBOS = [[1,2,3],[4,5,6],[7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

  def initialize
    @board = {}
    (1..9).each {|num| @board[num] = ' '}
  end

  def display_board
    system 'clear'
    puts "  #{board[1]}  | #{board[2]}  | #{board[3]}   "
    puts "----------------"
    puts "  #{board[4]}  | #{board[5]}  | #{board[6]}   "
    puts "----------------"
    puts "  #{board[7]}  | #{board[8]}  | #{board[9]}   "
  end

  def clear_board
    self.board = {}
    (1..9).each {|num| @board[num] = ' '}
  end

  def available_moves
    board.select { |_, mark| mark == ' '}
  end

  def two_in_a_row
    WINNING_COMBOS.each do |set|
      board_array = board.values_at(set[0], set[1], set[2])
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

  def check_board?
    board_keys = available_moves
    board_keys.empty?
  end

  def check_winner
    WINNING_COMBOS.each do |set|
      if board.values_at(set[0], set[1], set[2]).count('x') == 3
        return 'player'
      elsif board.values_at(set[0], set[1], set[2]).count('o') == 3
        return 'computer'
      end
    end
    nil
  end

end

class Game

  attr_accessor :ttt_board

  def initialize
    self.ttt_board = TttBoard.new
  end

  def player_move(num)
    ttt_board.board[num] = 'x'
  end

  def computer_move
    best_move = ttt_board.two_in_a_row
    if ttt_board.board[5] == ' '
      ttt_board.board[5] = 'o'
    elsif best_move
      ttt_board.board[best_move] = 'o'
    else
      possible_moves = ttt_board.available_moves
      ttt_board.board[possible_moves.keys.sample] = 'o'
    end
  end

  def run
    loop do
      ttt_board.clear_board
      ttt_board.display_board
      puts "Let's play!"

      begin
        puts 'Pick a number 1-9 to mark the board'
        num = gets.chomp.to_i

        available_nums = ttt_board.available_moves
        until available_nums.include?(num)
          puts 'That number is not available.  Pick a number on the board that is empty.'
          num = gets.chomp.to_i
        end

        player_move(num)
        winner = ttt_board.check_winner
        unless winner
          computer_move
          winner = ttt_board.check_winner
        end
        board_full = ttt_board.check_board?
        ttt_board.display_board

      end until winner || board_full

      if winner == 'player'
        puts 'You won!'
      elsif winner == 'computer'
        puts 'The Computer won!'
      else
        puts 'The board is full.'
      end

      puts 'Enter y if you would like to play again'
      play_again = gets.chomp

      break if play_again.downcase != 'y'
    end
  end
end

Game.new.run