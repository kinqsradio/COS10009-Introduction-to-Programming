require './input_functions'

# Complete the code below
# Use input_functions to read the data from the user

# define a Computer below:

class Computer
	attr_accessor :id, :manu, :model, :price
  	def initialize (id,manu,model,price)
		@id = id
		@manu = manu
      	@model = model
		@price = price
	end
end


def read_a_computer()
	# put more code here
	id = read_string("Enter computer id:")
	manu = read_string("Enter manufacturer:")
	model = read_string("Enter model:")
	price = read_float('Enter price:')
	computer = Computer.new(id,manu,model,price)
	return computer
end

def read_computers()
	count = read_integer("How many computers are you entering:")
	computers = Array.new()
	i = 0
	while i < count
		computer = read_a_computer()
		computers << computer
		i+=1
	end
	return computers	
end

def print_a_computer(computer)
	puts "Id: #{computer.id}"
	puts "Manufacturer: #{computer.manu}"
	puts "Model: #{computer.model}"
	printf("Price: %.2f\n", computer.price)
end

def print_computers(computers)
	i = 0
	while i < computers.length
		print_a_computer(computers[i])
		i+=1
	end

	
end

def main()
	computers = read_computers()
	print_computers(computers)
end

main()
