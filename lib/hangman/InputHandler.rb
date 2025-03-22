class InputHandler
  def initialize(minimum_input_length = 1)
    @minimum_input_length = minimum_input_length
  end

  def input
    while user_input = gets.strip
      return user_input if validate_input(user_input)

      puts ViewController.incorrect_input_message
    end
  end

  private

  def validate_input(input)
    length_good = input.length >= @minimum_input_length
    has_numbers = input =~ /\d/

    length_good && !has_numbers
  end
end
