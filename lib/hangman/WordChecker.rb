class WordChecker
  def check(secret_word, already_checked_chars)
    ciphered_secret_word(secret_word, already_checked_chars) == secret_word
  end

  def ciphered_secret_word(secret_word, already_checked_chars)
    ciphered_secret_word = secret_word.dup
    player_used_words = already_checked_chars.tally

    secret_word.chars.each do |secret_word_char|
      ciphered_secret_word.gsub!(secret_word_char, '_') unless player_used_words[secret_word_char.downcase]
    end

    ciphered_secret_word
  end
end
