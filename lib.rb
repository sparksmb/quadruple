class Quadruple

  def initialize
    @letters = ['A','B','C','D','E','F','G','H']
    @feedback = ""
    @score = 0
    @field = [
      [" "," "," "," "," "],
      [" "," "," "," "," "],
      [" "," "," "," "," "],
      [" "," "," "," "," "],
      [" "," "," "," "," "],
      [" "," "," "," "," "],
      [" "," "," "," "," "],
      [" "," "," "," "," "]
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
    @score += 1

    begin

      validate(move)

      r, c = from(move)
      digit = get_digit(r, c)

      r, c = to(move)
      @field[r][c] = digit

      seed_field(generate_next_up)

    rescue Exception => e
      @feedback = e.message
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

  def put_digit(r, c)

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

  def generate_next_up(n=3)
    next_up = []
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
end
