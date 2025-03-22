require 'msgpack'
class GameSerializer
  def serialize(obj)
    puts 'Saving the game!'
    msg = MessagePack.dump(obj)

    begin
      File.open('game.progress', 'w') do |file|
        file << msg
      end
    rescue StandardError
      puts 'Error during saving!'
    end
  end

  def unserialize
    obj = {}

    return unless save_exists?

    begin
      MessagePack.load(File.read('game.progress'))
    rescue StandardError
      puts 'Error during loading'
    end
  end

  def save_exists?
    File.exist?('game.progress')
  end
end
