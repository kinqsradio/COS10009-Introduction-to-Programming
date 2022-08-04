
def read_array(count)
  lines = Array.new()
  i = 0
  while i < count
    print "Enter text: "
    line = gets.chomp
    lines << line
    i+=1
  end
  return lines
end

def print_array(lines,count)
  # put code here
    i = 0
    puts 'Printing lines:'
    while i < count
        puts "#{i} #{lines[i]}"
        i+=1
    end
end

def main()
   # put code here 
   print 'How many lines are you entering? '
   count = gets.chomp.to_i
   lines = read_array(count)
   print_array(lines,count)
end

main()
