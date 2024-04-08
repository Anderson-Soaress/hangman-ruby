def game
  words = File.read('google-10000-english-no-swears.txt').split("\n")

  random_word = ''

  until random_word.length >= 5 && random_word.length <= 12 do
    random_word = words.sample
  end

  random_word
end