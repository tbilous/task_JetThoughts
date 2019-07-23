require 'ostruct'

module Assignment
  module Justifier
    extend self

    @@KNOWN_VERSIONS_REGEX = /v[12]/
    @@SPACES_REGEX = /\s+/

    def justify(input_str, n, version = 'v1')
      raise_if_argument_error(input_str, n, version)

      version == 'v1' ? justify_v1(input_str, n) : justify_v2(input_str, n)
    end

    private

    def justify_v1(input_str, n)
      input_str.scan(/.{1,#{n}}\b|.{1,#{n}}/).each(&:strip!).join("\n")
    end

    def justify_v2(input_str, n)
      input_words = input_str.split(@@SPACES_REGEX)
      state = initial_state(input_words.shift)

      res = input_words.each_with_object(state) do |current_word, state|
        current_word_len = current_word.length

        if current_word_len > n
          chunks = current_word.chars.each_slice(n).to_a.map(&:join)
          current_word = chunks.pop

          state.out.push(state.buffer.join(' '))
          state.out += chunks
          state.buffer = [current_word]
          state.current_line_len = current_word.length
        else
          if state.current_line_len + current_word_len + state.buffer.count <= n
            state.current_line_len += current_word_len
            state.buffer.push(current_word)
          else
            state.out.push(state.buffer.join(' '))
            state.buffer = [current_word]
            state.current_line_len = current_word.length
          end
        end

        state.last_seen = current_word
      end

      tail = res.buffer.join(' ')
      res.out.push(tail).join("\n")
    end

    def initial_state(first_word)
      OpenStruct.new(
        out: [],
        current_line_len: 0,
        buffer: [first_word],
        last_seen: first_word
      )
    end

    def raise_if_argument_error(input_str, n, version)
      unless input_str.respond_to?(:chars)
        raise ArgumentError, "input should respond to chars, got #{input_str.inspect}"
      end

      raise ArgumentError, "n should be an Integer, got #{n.inspect}" unless n.is_a?(Integer)

      unless version.is_a?(String) && version.match(@@KNOWN_VERSIONS_REGEX)
        raise ArgumentError, "version should be 'v1' or 'v2'"
      end
    end
  end
end
