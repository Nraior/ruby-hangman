class ViewController
  def self.present_word_to_player(ciphered_word)
    ciphered_word
  end

  def self.remaining_tries_count_message(tries_count_left)
    "You have #{tries_count_left} tries left"
  end

  def self.lose_game_message(secret_word)
    "You lost, secret word was #{secret_word}"
  end

  def self.question_load_game_message
    'There is saved game, should we load it? enter Y if yes'
  end

  def self.win_message(tries, minimum_tries)
    "Yay, you won, it only took you #{tries} tries out of #{minimum_tries} minimum"
  end

  def self.game_loaded_message
    'Game Loaded'
  end

  def self.game_saved_message
    'Game Saved'
  end
end
