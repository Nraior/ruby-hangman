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

  def start(min_length, max_length, max_errors)
    @last_min_length = min_length
    @last_max_length = max_length
    @max_errors = max_errors
    @last_max_errors = max_errors
    @tried_letters = []
    draw_secret_word(min_length, max_length) unless max_length.nil?
    @playing = true

    check_and_handle_load_game
    game_loop
  end

  private

  def check_and_handle_load_game
    return unless @serializer.save_exists?

    puts ViewController.question_load_game_message
    input = @input_handler.input
    process_load_ask_input(input)
  end

  def game_loop
    while @playing
      puts ViewController.present_word_to_player(@word_checker.ciphered_secret_word(@secret_word, @tried_letters))
      puts ViewController.remaining_tries_count_message(@last_max_errors - tries_count)
      input = @input_handler.input
      process_input(input)
    end
  end

  def process_load_ask_input(input)
    input = input.chomp.downcase

    return unless input == 'y'

    load_game
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

  def load_game
    saved_game_state = @serializer.unserialize

    return unless saved_game_state.is_a? Hash

    puts ViewController.game_loaded_message
    @secret_word = saved_game_state['secret_code']
    @tried_letters = saved_game_state['tried_letters']
  end

  def handle_guess(word)
    guessed_letter = word.to_s[0]
    @tried_letters << guessed_letter
    whole_word_check = @word_checker.whole_word_check(@secret_word, word)
    check_result = @word_checker.check(@secret_word, @tried_letters)
    handle_win if whole_word_check || check_result
    handle_lose if tries_count >= @max_errors
  end

  def save
    game_progress = { secret_code: @secret_word, tried_letters: @tried_letters }
    @serializer.serialize(game_progress)
    puts ViewController.game_saved_message
  end

  def handle_win
    @playing = false
    puts ViewController.win_message(tries_count)
  end

  def handle_lose
    @playing = false
    puts ViewController.lose_game_message(@secret_word)
    start(@last_min_length, @last_max_length, @last_max_errors)
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
