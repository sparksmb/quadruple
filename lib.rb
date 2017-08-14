class Quadruple

  def initialize
    @cell_width = 1
    @letters = ['A','B','C','D','E','F','G','H']
    @feedback = ""
    @score = 0
    @field = [
      [" "," ","1"," "," "],
      [" "," ","1"," "," "],
      ["1","1"," "," "," "],
      [" "," "," "," "," "],
      [" "," "," "," "," "],
      [" "," "," "," "," "],
      [" "," "," "," "," "],
      [" "," "," "," "," "]
    ]

    @adjacent_methods = [
      :above,
      :above_right,
      :right,
      :down_right,
      :down,
      :down_left,
      :left,
      :above_left
    ]
    @options = [1,2,4,8]
    seed_field(generate_next_up)
  end

  def print_instructions
    puts "Instructions here..."
    puts
  end

  def score
    @score
  end

  def update(move)
    @feedback = ""

    #begin

      validate(move)

      r, c = from(move)
      digit = get_digit(r, c)

      r, c = to(move)
      put_digit(r, c, digit)

      coalesce(r, c)

      seed_field(generate_next_up)

    #rescue Exception => e
    #  @feedback = e.message
    #end
  end

  def coalesce(r, c)
    adjacent = [[r,c]]
    digit = @field[r][c]
    index = 0
    while index <= adjacent.size - 1
      ap "-------------- Loop #{adjacent.size} ---------------"
      adjacent += search(adjacent, index, digit)
      ap adjacent
      index += 1
    end

    if adjacent.size >= 4
      clear(adjacent)
      # wip need to compute quadruple and detect cell width
      @field[r][c] = digit.to_i * 4
      score(adjacent)
    end
  end

  def validate(move)
    validate_first_coord(move[0..1])
    validate_second_coord(move[2..3])
  end

  def validate_first_coord(first_coord)
    if valid(first_coord)
      r, c = coordinates(first_coord)
      if @field[r][c] != " "
        return true
      else
        raise "No digit to select at first coordinate."
      end
    else
      raise "First corrdinate is invalid."
    end
  end

  def validate_second_coord(second_coord)
    if valid(second_coord)
      r, c = coordinates(second_coord)
      if @field[r][c] == " "
        return true
      else
        raise "Cell is occupied at second coordinate."
      end
    else
      raise "Second corrdinate is invalid."
    end
  end

  def from(move)
    coordinates(move[0..1])
  end

  def to(move)
    coordinates(move[2..3])
  end

  def get_digit(r, c)
    digit = @field[r][c]
    @field[r][c] = " "
    digit
  end

  def put_digit(r, c, digit)
    @field[r][c] = digit
  end

  def coordinates(move)
    row = @letters.index(move[0])
    col = move[1].to_i - 1
    [row, col]
  end

  def seed_field(next_up)
    count = empty_field_positions
    if count <= 5
      next_up = generate_next_up(count)
      seed(next_up)
      return "gameover"
    else
      seed(generate_next_up)
    end
  end

  def seed(next_up)
    row, col = 0
    next_up.each { |digit|
      loop do
        row = rand(8)
        col = rand(5)
        break if @field[row][col] == " "
      end
      @field[row][col] = digit
    }
  end

  def draw
    next_up = generate_next_up
    puts
    puts "Score: #{@score}"
    puts "Next up: #{next_up.join(", ")}"
    puts
    puts "  1 2 3 4 5 ".light_black
    @field.each_with_index { |row, index|
      puts " +-+-+-+-+-+".light_black
      print @letters[index].light_black
      print "|".light_black
      row.each{ |digit|
        print_digit(digit)
        print "|".light_black
      }
      puts
    }
    puts " +-+-+-+-+-+".light_black
    puts
    puts @feedback
  end

  def print_digit(digit)
    if digit.to_s == "1"
      print digit.to_s.yellow
    elsif digit.to_s == "2"
      print digit.to_s.blue
    elsif digit.to_s == "4"
      print digit.to_s.green
    elsif digit.to_s == "8"
      print digit.to_s.red
    else
      print digit.to_s
    end
  end

  def generate_next_up(n=2)
    next_up = [1]
    n.times { next_up << @options[rand(4)] }
    next_up
  end

  def empty_field_positions
    count = 0
    @field.each { |row|
      count += row.join('').count(" ")
    }
    count
  end

  def valid(move)
    is_valid = false
    if @letters.include? move[0] and move[1].to_i.between?(1, 5)
      is_valid = true
    end
    is_valid
  end

  def search(adjacent, index, digit)
    #ap "adjacent for index #{index}"
    #ap adjacent
    hits = []
    r, c = adjacent[index]

    @adjacent_methods.each { |m|
      x, y = method(m).call r, c
      if x.between?(0,4) and y.between?(0,8)
        if @field[x][y].to_s == digit.to_s and
          adjacent.detect {|coord| coord[0] == x and coord[1] == y} == nil
          hits << [x, y] 
        end
      end
    }
    hits
  end

  def clear(adjacent)
    adjacent.each{|coord|@field[coord[0]][coord[1]] = " "}
  end

  def score(adjacent)
    @score += adjacent.size * 100
  end

  def above(r, c)
    [r - 1, c]
  end

  def above_right(r, c)
    [r - 1, c + 1]
  end

  def right(r, c)
    [r, c + 1]
  end

  def down_right(r, c)
    [r + 1, c + 1]
  end

  def down(r, c)
    [r + 1, c]
  end

  def down_left(r, c)
    [r + 1, c - 1]
  end

  def left(r, c)
    [r, c - 1]
  end

  def above_left(r, c)
    [r - 1, c - 1]
  end
end
