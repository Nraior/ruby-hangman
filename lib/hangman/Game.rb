require_relative 'ViewController'
require_relative 'InputHandler'
require_relative 'WordChecker'
require_relative 'GameSerializer'
class Game
  def initialize(wordsloader)
    @loader = wordsloader
    @words = @loader.load_words
    @input_handler = InputHandler.new
    @word_checker = WordChecker.new
    @serializer = GameSerializer.new
    @playing = false
    @tried_letters = []
  end

  def load_game(secret_word, tried_letters)
    puts ViewController.game_loaded_message
    @secret_word = secret_word
    @tried_letters = tried_letters
  end

  def start(min_length, max_length, max_errors)
    @last_min_length = min_length
    @last_max_length = max_length
    @tried_letters = []
    draw_secret_word(min_length, max_length) unless max_length.nil?
    @playing = true

    inital_loop
    @max_errors = @secret_word.length + max_errors
    game_loop
  end

  def inital_loop
    # Check and ask for save load
    puts ViewController.question_load_game_message
    input = @input_handler.input
    process_load_ask_input(input) if @serializer.save_exists?
  end

  def game_loop
    while @playing
      puts ViewController.present_word_to_player(@word_checker.ciphered_secret_word(@secret_word, @tried_letters))
      puts ViewController.remaining_tries_count_message(@max_errors - tries_count)
      input = @input_handler.input
      process_input(input)
    end
  end

  def process_load_ask_input(input)
    input = input.chomp.downcase

    return unless input == 'y'

    obj = @serializer.unserialize

    load_game(obj['secret_code'], obj['tried_letters'])
  end

  def process_input(input)
    input = input.chomp.downcase
    case input
    when 'save'
      save
    when 'exit'
      handle_quit
    when 'fortfeit'
      handle_lose
    else
      handle_guess(input.downcase)
    end
  end

  def handle_guess(word)
    guessed_letter = word.to_s[0]
    @tried_letters << guessed_letter
    check_result = @word_checker.check(@secret_word, @tried_letters)
    handle_win if check_result
    handle_lose if tries_count > @max_errors
  end

  def save
    game_progress = { secret_code: @secret_word, tried_letters: @tried_letters }
    @serializer.serialize(game_progress)
    puts ViewController.game_saved_message
  end

  def handle_win
    @playing = false
    puts ViewController.win_message(tries_count, @secret_word.length)
  end

  def handle_lose
    @playing = false
    puts ViewController.lose_game_message(@secret_word)
    start(@last_min_length, @last_max_length, @last_max_length)
  end

  def handle_quit
    @playing = false
  end

  def draw_secret_word(min_length, max_length)
    @secret_word = @words.filter { |word| word.length.between?(min_length, max_length) }.sample
  end

  def tries_count
    @tried_letters.length
  end
end
