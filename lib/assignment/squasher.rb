require 'ostruct'

module Assignment
  module Squasher
    extend self

    def squash(input_str)
      raise_if_argument_error(input_str)

      input_chars = input_str.chars
      state = initial_state(input_chars.shift)

      res = input_chars.each_with_object(state) do |current_char, state|
        if (current_char.ord - state.last_seen.ord).abs == 1
          state.range_len += 1
          state.out.push(state.last_seen) unless state.range_first_char
          state.range_first_char ||= state.last_seen
          state.range_last_char = current_char
        else
          state.out.push('-') if state.range_len > 2
          state.out.push(state.last_seen)
          state.range_first_char = nil
          state.range_last_char = nil
          state.range_len = 1
        end

        state.last_seen = current_char
      end

      state.out.push('-') if state.range_len > 2
      res.out.push(res.last_seen).join
    end

    private

    def initial_state(first_char)
      OpenStruct.new(
        out: [],
        last_seen: first_char,
        range_first_char: nil,
        range_last_char: nil,
        range_len: 1
      )
    end

    def raise_if_argument_error(input_str)
      unless input_str.respond_to?(:chars)
        raise ArgumentError, "input should respond to chars, got #{input_str.inspect}"
      end
    end
  end
end
