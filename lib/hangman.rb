def game
  words = File.read('google-10000-english-no-swears.txt').split("\n")

  random_word = ''

  until random_word.length >= 5 && random_word.length <= 12 do
    random_word = words.sample
  end

  hidden_word = random_word.split('').map{|letter| letter = '_'}
  lifes = 10
  wrong_guesses = []
  win = false

  until lifes == 0 do 
    puts "\nYou have #{lifes} lifes."
    puts "\nWrong guesses: #{wrong_guesses.join(" ")}" if wrong_guesses.length > 0
    puts "\nType a letter or type 'guess' if you want to guess the word: "
    puts "\n#{hidden_word.join(' ')}\n"
    puts ''
    guess = gets.chomp

    if guess == 'guess'
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

  puts "\nNo more lifes." if lifes == 0
  if !win 
    puts "\nGuess the word:"
    guess = gets.chomp
  end
  guess = random_word ? "Congratulations, you win!" : "You lose, the word is #{random_word}" 
end

puts game