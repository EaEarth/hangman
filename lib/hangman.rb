class Hangman

    attr_accessor:game_state

    def initialize
        reset()
        @words = File.readlines("5desk.txt",chomp: true)
        @words = @words.select { |word| word.length>4 && word.length<13 }
    end

    def reset
        @game_state = "new_game"
        @letters = []
        @guess_letters = []
        @correct_word = ""
        @guess_count = 0
    end
    
    def load_game
        require 'json'
        file = File.read("file_save.txt")
        data = JSON.parse(file)
        @game_state = data["game_state"]
        @letters = data["letters"]
        @correct_word = data["correct_word"]
        @guess_letters = data["guess_letters"]
        @guess_count = data["guess_count"]
    end

    def save_game
        require 'json'
        temp_hash = {
            "game_state" => @game_state,
            "letters" => @letters,
            "correct_word" => @correct_word,
            "guess_letters" => @guess_letters,
            "guess_count" => @guess_count
        }
        File.open("file_save.txt" , "w") do |f|
            f.write(JSON.pretty_generate(temp_hash))
        end
    end

    def new_game
        reset()
        puts "Starting new game"
        @correct_word = @words.sample.downcase
        @game_state = "playing"
        1.upto(@correct_word.length()) do 
            @letters.push("_ ")
        end
    end

    def play
        while @game_state == "playing" do
            puts " "
            puts "Word : " + @letters.join().to_s
            puts "Your guess : " + @guess_letters.join(" ").to_s
            puts "Chance left : " + (5 - @guess_count).to_s 
            puts "Guessing a letter or type 'save' to save game"
            input = gets.chomp().strip
            if(input.length > 1 && input.downcase != "save")
                puts "Please guessing a letter or type 'save' to save game"
            elsif input.downcase == "save"
                save_game()
                puts "Game saved!"
            else
                guessing_check(input.downcase)
            end
            if(game_state == "new_game")
                puts "Press enter to play again"
                gets
                new_game()
            end
        end
    end

    def guessing_check(letter)
        if(@guess_letters.include?(letter))
            @guess_count += 1
            puts "You already guess this letter."
        elsif (!@correct_word.include?(letter))
            @guess_count += 1
            @guess_letters.push(letter)
            puts "Unfortunately, the word doesn't include this letter."
        else
            @guess_letters.push(letter)
            temp = 0
            while(@correct_word.index(letter,temp) != nil) do
                @letters[@correct_word.index(letter,temp)] = letter
                temp = @correct_word.index(letter,temp)+1
            end
            puts "You guess correctly!"
        end
        check_result()
    end

    def check_result
        if @guess_count >= 5
            puts "You lose, out of chance!"
            puts "The correct word is : " + @correct_word
            @game_state = "new_game"
        elsif @letters.join() == @correct_word
            puts "You win!"
            puts "The correct word is : " + @correct_word
            @game_state = "new_game"
        end
    end
end 

game = Hangman.new()
game.load_game()
if(game.game_state == "new_game") 
    game.new_game()   
end
game.play()