 
# takes a number and writes that number to a file then on each line
# increments from zero to the number passed
def write(aFile, number)
    # You might need to fix this next line:
    aFile.puts(number.to_s) #Samantha's note: replaced the string "number" with the value number
    index = 0
     while (index < number)
      aFile.puts(index.to_s) #Quang's notes: should've put 'index.to_s' instead of 'number'
      index += 1
    end
  end
  
# Read the data from the file and print out each line
def read(aFile)
  # Defensive programming:
  count = aFile.gets.to_s.chomp #Quang's note: add to_s because the function is_numeric? takes string values. Then, add .chomp to remove any \n that might be invisible to us.
  if (is_numeric?(count)) #Samantha's note: added '?' in to define the method. also matches with the below is_numeric?(obj) method
    count = count.to_i
  else
    count = 0
    puts "Error: first line of file is not a number"
  end
  #Quang's notes: Should we seperate the print lines action into another function. In so doing, the function read(aFile) will be responsible for only one task ==> Cohesive.
  index = 0
  while (count > index)#Samantha's note: correct relation to count being more than index
    line = aFile.gets
    puts "Line read: " + line.to_s #Quang's notes: add to_s into line.
    #Samantha's note: increase index by 1.
    index += 1 
  end
end

  
  # Write data to a file then read it in and print it out
  def main
    aFile = File.new("mydata.txt", "w") #Samantha's note: adding the reading  & writing function to main.
    counter = 10 #Samantha's note: what is the point of this variable?
    write(aFile, counter)
    aFile.close
    #Davis note: Close the file for writing. I think it's a safer operation before the reading file
    aFile = File.new("mydata.txt", "r")
    read(aFile)
    aFile.close #Davis notes: Close the file for read
  end
  
  # returns true if a string contains only digits
  def is_numeric?(obj)
    if /[^0-9]/.match(obj) == nil #Samantha's note: changing == to =~ as =~ will match the expression againt a string, which is what is what we need to happen.
       return true  #Quang's note: write "return true", not only writing "true"
       #Davis note: Should be return false
    end #Quang's note: write "else" instead of "end" // samantha's note: changing back to end as warning advised else without rescue is useless
       return false #Quang's note: write "return false", not only writing "false"
       #Davis note: Should be return true 
  end
  
  main
  
