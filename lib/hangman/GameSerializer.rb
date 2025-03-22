require 'msgpack'
class GameSerializer
  def serialize(obj)
    puts 'Saving the game!'
    msg = MessagePack.dump(obj)

    File.open('game.progress', 'w') do |file|
      file << msg
    end
  end

  def unserialize
    obj = {}
    File.open('game.progress') do |file|
      obj = MessagePack.load(file)
    end
    obj
  end

  def save_exists?
    File.exist?('game.progress')
  end
end
