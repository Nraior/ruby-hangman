class WordsLoader
  def initialize(file_path, min_length = 5, max_length = 12)
    @file_path = file_path
    @min_length = min_length
    @max_length = max_length
  end

  def load_words
    words = []
    file = load_file(@file_path)

    file.each do |word|
      word = word.strip
      words.push(word) if word.length.between?(@min_length, @max_length)
    end
    file.close
    words
  end

  private

  def load_file(path)
    File.open(path)
  end
end
