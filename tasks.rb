# require './tasks'
module Tasks
  require 'ostruct'

  # r = Tasks::PartOneTaskOne.new('abcdab987612').squash
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

  # r = Tasks::PartOneTaskTwoVerOne.new('To be or not to be -that is the question', 5).justify
  class PartOneTaskTwoVerOne
    def initialize(*args)
      @v1, @v2 = args
    end

    def justify
      @v1.scan(/.{1,#{@v2}}\b|.{1,#{@v2}}/).each(&:lstrip!).join("\n")
    end
  end

  # r = Tasks::PartOneTaskTwoVerTwo.new('To be or not to be -that is the question', 5).justify
  class PartOneTaskTwoVerTwo
    def initialize(*args)
      v1, v2 = args
      @input_str = v1
      @n = v2.to_i
      @input_words = @input_str.split(/\s+/)
    end

    def justify
      res = @input_words.each_with_object(initial_state) do |current_word, state|
        current_word_len = current_word.length

        if current_word_len > @n
          chunks = current_word.chars.each_slice(@n).to_a.map(&:join)
          current_word = chunks.pop

          state.out.push(state.buffer.join(' '))
          state.out += chunks
          state.buffer = [current_word]
          state.current_line_len = current_word.length
        elsif state.current_line_len + current_word_len + state.buffer.count <= @n
          state.current_line_len += current_word_len
          state.buffer.push(current_word)
        else
          state.out.push(state.buffer.join(' '))
          state.buffer = [current_word]
          state.current_line_len = current_word.length
        end
      end

      res.out.push(res.last_seen).join("\n")
    end

    private

    def initial_state
      first_word = @input_words.shift
      OpenStruct.new(
        out: [],
        current_line_len: 0,
        buffer: [first_word],
        last_seen: first_word
      )
    end
  end

  # require './tasks'
  # r = Tasks::PartTwo.new.convert
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
