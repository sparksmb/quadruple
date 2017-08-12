class Quadruple

  def initialize
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
    @score += 1

    count = empty_field_positions
    if count <= 5
      next_up = generate_next_up(count)
      seed_field(next_up)
      return "gameover"
    else
      seed_field(generate_next_up)
    end

  end

  def seed_field(next_up)
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
    letters = ['A','B','C','D','E','F','G','H']
    puts
    puts "Score: #{@score}"
    puts "Next up: #{next_up.join(", ")}"
    puts
    puts "  1 2 3 4 5 "
    @field.each_with_index { |row, index|
      puts " +-+-+-+-+-+"
      puts "#{letters[index]}|#{row.join("|")}|"
    }
    puts " +-+-+-+-+-+"
    puts
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
end
