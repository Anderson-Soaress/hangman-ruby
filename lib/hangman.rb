require 'yaml'

def save_game(random_word, hidden_word, lifes, wrong_guesses)
  Dir.mkdir('saved_games') unless Dir.exist?('saved_games')

  filename = "saved_games/saved_game.yml"

  save = { random_word: random_word, hidden_word: hidden_word, lifes: lifes, wrong_guesses: wrong_guesses}

  File.open(filename, 'w') {|file| file.write(save.to_yaml)}
  
end

def game(menu_option)
  words = File.read('google-10000-english-no-swears.txt').split("\n")

  case menu_option
  when '1'
    random_word = ''
    lifes = 10
    wrong_guesses = []
    until random_word.length >= 5 && random_word.length <= 12 do
      random_word = words.sample
    end
    hidden_word = random_word.split('').map{|letter| letter = '_'}
  when '2'
    saved_infos = YAML.load_file("saved_games/saved_game.yml")
    random_word = saved_infos[:random_word]
    hidden_word = saved_infos[:hidden_word]
    lifes = saved_infos[:lifes]
    wrong_guesses = saved_infos[:wrong_guesses]
  end  

  invalid_input = true
  win = false
  game_saved = false

  puts random_word
  until lifes == 0 do 
    puts "\nYou have #{lifes} lifes."
    puts "\nWrong guesses: #{wrong_guesses.join(" ")}" if wrong_guesses.length > 0
    puts "\nType a letter or type 'guess' if you want to guess the word or type 'save' to save the game: "
    puts "\n#{hidden_word.join(' ')}\n"
    puts ''
    
    while invalid_input do
      guess = gets.chomp.downcase
      break if guess == 'guess' || guess == 'save'
      if guess.length != 1
        puts "\nThis input is invalid."
      elsif wrong_guesses.include?(guess) || hidden_word.include?(guess)
        puts "\nYou already typed #{guess}."
      else
        break
      end
      puts "Please, type a valid value: "
    end

    if guess == 'guess'
      break
    elsif guess == 'save'
      save_game(random_word, hidden_word, lifes, wrong_guesses)
      game_saved = true
      break
    else
      if random_word.split('').include?(guess)
        puts "\nHit!"
        random_word.split('').each_with_index {|letter, index| hidden_word[index] = guess if letter == guess }
        if !hidden_word.include?("_")
          win = true
          guess = random_word
          break
        end
      else 
        puts "\nMissed. You lost a life."
        wrong_guesses << guess
        lifes -= 1
      end
    end
  end

  if !game_saved 
    puts "\nNo more lifes." if lifes == 0
    if !win 
      puts "\nGuess the word:"
      guess = gets.chomp
    end
    guess == random_word ? "Congratulations, you win!" : "You lose, the word is #{random_word}"
  end
end

invalid_input = true

while invalid_input do 
  puts "\n--HANGMAN--"
  puts "1- New game"
  puts "2- Continue"
  puts "3- Exit"
  
  menu_input = gets.chomp
  
  case menu_input
  when '1'
    puts game('1')
    invalid_input = false  
  when '2'
    puts game('2')
    invalid_input = false
  when '3'
    invalid_input = false
  else
    invalid_input = true
  end
end