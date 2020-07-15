class Hangman

    def initialize
        @game_state = "new_game"
        @letters = ["","","","","","","","","","","",""]
        @correct_word = ["","","","","","","","","","","",""]
        @words = File.readlines("5desk.txt",chomp: true)
        @words = words.select { |word| word.length>4 && word.length<13 }
    end
    
    def load_game
        require 'json'
        file = File.read("file_save.txt")
        data = JSON.parse(file)
        @game_state = data["game_state"]
        @letters = data["letters"]
        @correct_word = data["correct_word"]
        file.close
    end

    def save_game
        require 'json'
        temp_hash = {
            "game_state" => @game_state
            "letters" => @letters
        }
        File.open("file_save.txt" , "w") do |f|
            f.write(JSON.pretty_generate(temp_hash))
        end
    end

end 
