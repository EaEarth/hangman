words = File.readlines("5desk.txt",chomp: true)
words = words.select { |word| word.length>4 && word.length<13 }
puts words
