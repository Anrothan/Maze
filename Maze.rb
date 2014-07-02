# This program is meant to read a "$maze" and return the $solution of the $maze (eg, what takes it from @ to %)

# This reads any $maze into an array of arrays with each node and line separate. With this, 
# each node has a unique array index which can be used to map out all four directions. 


# Looks at each of the surrounding nodes and determines if they are open spaces. 
# Open spaces are added to the candidate array. 

class Maze 

#  attr_accessor :start, :solutions

  def initialize(maze)
    @maze_file = maze
    @maze = IO.read(@maze_file).split("\n").map! { |line| line.split("") }
    @num_rows = IO.read(@maze_file).split("\n").size
    @num_columns = @maze[0].size
    @prohibited_nodes = %w[o] # Do not search_from these nodes. 
    @solutions = [] # Will become @solutions[*Solution*][*Node*][*X or Y coordinate*]
  end

# Generates the solution(s) for the maze as prints the shortest one.
  def maze_solve
    @searched_nodes = []
    @maze.each_with_index { |line, x| @start ||= [x, line.index("@")] if line.include?("@") }
    search_from(@start[0], @start[1], Array.new)
  end

#  def shortest_solution
#    @solutions.each { |solution| }
#  end

# Tells whether a candidate node should be searched or not. 
  def prohibited_node?(x, y, solution)
    (@prohibited_nodes.include? @maze[x][y]) || (solution.include? [x, y])
  end

# Searches a particular node for nearby nodes that are (1) not walls and 
# (2) not a previously searched node. 
  def search_from(x, y, solution)
    puts "Searching: [#{x}, #{y}]"
    solution << [x, y]

    if @maze[x][y] == "%"
      puts "Updating @solutions... match with end node confirmed"
      @solutions << solution
      puts "\tTemporary solution: #{solution.inspect}"
      puts "\tFinal solutions array: #{@solutions.inspect}"


    else
      puts "\tTemporary solution: #{solution.inspect}"
      puts "\tFinal solutions array: #{@solutions.inspect}"
      puts "Searching next nodes..."
      search_from(x - 1, y, solution) unless x == 0                 || prohibited_node?(x - 1, y, solution) 
      search_from(x + 1, y, solution) unless x == @num_rows - 1     || prohibited_node?(x + 1, y, solution)

      search_from(x, y + 1, solution) unless y == @num_columns - 1  || prohibited_node?(x, y + 1, solution)
      search_from(x, y - 1, solution) unless y == 0                 || prohibited_node?(x, y - 1, solution)

    end 
    puts "Returning to earlier branch"
  end
end

maze = Maze.new("maze7.txt")
maze.maze_solve
puts maze.solutions.inspect


# OLD ALGORITHM. FLAWED DUE TO LACK OF RECURSION. 
=begin

def next_node(current_node, previous_node = nil)
  return "Invalid node" unless current_node.is_a? Array 
  row, column = current_node
  
# Directions is an array which contains each surrounding node. Nodes beyond the maze constraints
# are not included. 
  directions = []
  directions << [row - 1, column] unless row == 0 
  directions << [row + 1, column] unless row == $ROWS - 1
  directions << [row, column + 1] unless column == $COLUMNS - 1
  directions << [row, column - 1] unless column == 0
  candidate = []
  
  directions.each do |row, column| 
    if ($maze[row][column] == "#" || $maze[row][column] == "%") && [row, column] != previous_node\
	&& !($prohibited_nodes.include?([row,column]))
	  candidate << [row, column]
	end 
  end
  if candidate.size > 1
	log_branch(current_node, candidate)
  elsif candidate.size == 0 
    puts "Dead end. Returning to last branch."
	current_size = $solution.size
	branch_index = $solution.index($branches.last)
	(current_size - branch_index - 2).times { $solution.delete_at(branch_index + 1) }
	#Compare branch_options to prohibited_nodes. If all used up delete branches.last and
	#go back another branch
	$branches.size - 1
  end
  return candidate 
end

# Under construction. Once finished, this will facilitate unlimited branching behavior. 
def log_branch(current_node, candidate)
  $branches << current_node
  $prohibited_nodes << candidate[0] # Prevents recurrence of branches by forbidding access to
									# paths already used. 
  $branch_options << candidate
  puts $branch_options.inspect
end

# NOTE: While the declaration of global variables forces the program to be functional, 
# this is clearly messy. After program works, go back and make these into local class variables. 
$maze_file = "maze5.txt"
$maze = IO.read($maze_file).split("\n").map! { |line| line.split("") }
$ROWS = IO.read($maze_file).split("\n").size
$COLUMNS = $maze[0].size
$branches = [] # Collects the node indexes of all points where multiple open spaces are available. 
$solution = [] # An array of indexes corresponding to the multidimentional $maze array. 
$prohibited_nodes = [] # Nodes that should always be avoided. Mostly used for preventing
						# use of the same paths. 
$branch_options = []
						
# The first step of the solution is defined as an array containing the index of @ in the maze. 
$maze.each_with_index { |line, row| $solution << [row, line.index("@")] if line.include?("@") }
# Next, the program finds the next node without passing in a previous node (NOTE: Maybe 
# this could be improved by telling next_node() how to handle the @ symbol? See if this can
# be simplified!)
$solution << next_node($solution[0])[0]
# The last step of the solution is defined as an array containing the index of % in the maze. 
$maze.each_with_index { |line, row| $solution << [row, line.index("%")] if line.include?("%") }


next_node_cand = []

# Runs a loop which searches for successive nodes until the result from next_node() returns
# the index of the end of the maze. 

until next_node_cand[0] == $solution.last
next_node_cand = next_node($solution[-2], $solution[-3])
next if next_node_cand.empty? # Program skips an iteration if a dead end in the maze is found. 
$solution[-1,0] = [next_node_cand[0]] unless next_node_cand[0] == $solution.last
end

# NOTE: This could be rendered much more interesting via a graphical representation of the 
# result. Consider adding once program is fully functional. 
puts "Solution found: #{$solution}"

=end
