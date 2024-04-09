class Game

  attr_accessor :random_word, :hidden_word, :lifes, :wrong_guesses

  def initialize
    @random_word = generate_word()
    @hidden_word = random_word.split('').map{|letter| letter = '_'}
    @lifes = 10
    @wrong_guesses = []
  end

  def generate_word
    words = File.read('google-10000-english-no-swears.txt').split("\n")
    random_word = ''
    until random_word.length >= 5 && random_word.length <= 12 do
      random_word = words.sample
    end
    random_word
  end

  def guess_word
    puts "\nNo more lifes." if lifes == 0
    puts "\nGuess the word:"
    guess = gets.chomp
    guess == random_word ? "Congratulations, you win!" : "You lose, the word is #{random_word}."
  end

  def guess_letter(guess)
    if random_word.split('').include?(guess)
      puts "\nHit!"
      random_word.split('').each_with_index {|letter, index| hidden_word[index] = guess if letter == guess }
    else 
      puts "\nMissed. You lost a life."
      self.wrong_guesses << guess
      self.lifes -= 1
    end
  end

  def play_game
    guess = ''
    puts random_word
    until lifes == 0
      puts "\nYou have #{lifes} lifes."
      puts "\nWrong guesses: #{wrong_guesses.join(" ")}" if wrong_guesses.length > 0
      puts "\n#{hidden_word.join(' ')}\n"
      puts "
1- Guess the word
2- Save
Or type a letter:"

      loop do
        guess = gets.chomp.downcase
        if guess.length != 1
          puts "\nThis input is invalid."
        elsif wrong_guesses.include?(guess) || hidden_word.include?(guess)
          puts "\nYou already typed #{guess}."
        else
          break
        end
        puts "Please, type a valid value: "
      end

      case guess
      when '1'
        puts guess_word()
        break
      when '2'

      else
        guess_letter(guess)
        puts guess_word() if lifes == 0
      end
    end
  end
end


game = Game.new
game.play_game