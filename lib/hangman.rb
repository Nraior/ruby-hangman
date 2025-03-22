require_relative 'hangman/Game'
require_relative 'hangman/WordsLoader'

words_loader = WordsLoader.new('google-10000-english-no-swears.txt')
game = Game.new(words_loader)

game.start(5, 12, 10)
