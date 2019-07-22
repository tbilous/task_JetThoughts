module Tasks
  require 'ostruct'

  # example: r = Tasks::PartOneTaskOne.new('abcdab987612').squash
  class PartOneTaskOne
    def initialize(input_str)
      @input_chars = input_str.chars
      @first_char = @input_chars.shift
    end

    def squash
      res = @input_chars.each_with_object(initial_state) do |current_char, state|
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

      res.out.push(res.last_seen).join
    end

    private

    def initial_state
      OpenStruct.new(
        out: [],
        last_seen: @first_char,
        range_first_char: nil,
        range_last_char: nil,
        range_len: 1
      )
    end
  end

  # example: r = Tasks::PartOneTaskTwoVerOne.new('To be or not to be -that is the question', 5, 'v1').justify
  class PartOneTaskTwo
    def initialize(*args)
      @input_str, @n, @config = args
    end

    def justify
      @config == 'v1' ? var_1 : var_2
    end

    private

    def var_1
      @input_str.scan(/.{1,#{@n}}\b|.{1,#{@n}}/).each(&:strip!).join("\n")
    end

    def var_2
      input_words = @input_str.split(/\s+/)
      first_word = input_words.shift

      initial_state = OpenStruct.new(
          out: [],
          current_line_len: 0,
          buffer: [first_word],
          last_seen: first_word
      )

      res = input_words.reduce(initial_state) do |state, current_word|
        current_word_len = current_word.length

        if current_word_len > @n
          chunks = current_word.chars.each_slice(@n).to_a.map(&:join)
          current_word = chunks.pop

          state.out.push(state.buffer.join(" "))
          state.out += chunks
          state.buffer = [current_word]
          state.current_line_len = current_word.length
        else
          if state.current_line_len + current_word_len + state.buffer.count <= @n
            state.current_line_len += current_word_len
            state.buffer.push(current_word)
          else
            state.out.push(state.buffer.join(" "))
            state.buffer = [current_word]
            state.current_line_len = current_word.length
          end
        end

        state.last_seen = current_word
        state
      end

      res.out.push(res.last_seen).join("\n")
    end
  end

  # example: r = Tasks::PartTwo.new.convert
  class PartTwo
    require 'json'
    require 'yaml'

    def initialize
      incoming_file = JSON.pretty_generate(YAML.load_file('translations_simple.yml'))
      @hash = JSON.parse(incoming_file)
    end

    def convert
      res = build_tree(@hash).to_yaml
      File.write('./translations.yml', res)
    end

    private

    def set(hash, path, val)
      parts = path.split('.')
      scope = hash

      parts[0..-2].each do |hop|
        scope[hop] ||= {}
        scope = scope.fetch(hop)
        raise "Could not add value into scalar property #{path}" unless scope.is_a?(Hash)
      end

      scope[parts[-1]] = val
    end

    def build_tree(data)
      res = {}
      data.each do |k, v|
        set(res, k, v)
      end

      res
    end
  end
end
