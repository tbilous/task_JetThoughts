require 'minitest/autorun'
require_relative '../../lib/assignment/justifier'

describe 'Assignment::Justifier' do
  describe '#justify' do
    before do
      @input = 'To be or not to be that is the question'
      @n = 5
      @valid_output = "To be\nor\nnot\nto be\nthat\nis\nthe\nquest\nion"
    end

    describe 'v1' do
      it 'must properly squash sample string' do
        Assignment::Justifier.justify(@input, @n).must_equal(@valid_output)
        Assignment::Justifier.justify(@input, @n, 'v1').must_equal(@valid_output)
      end

      it 'must work with different n' do
        Assignment::Justifier.justify(@input, 20).must_equal("To be or not to be\nthat is the question")
      end
    end

    describe 'v2' do
      it 'must properly squash sample string' do
        Assignment::Justifier.justify(@input, @n, 'v2').must_equal(@valid_output)
      end

      it 'must work with different n' do
        Assignment::Justifier.justify(@input, 25, 'v2').must_equal("To be or not to be that is\nthe question")
      end
    end

    describe 'validations' do
      it 'raises on invalid input' do
        err = -> { Assignment::Justifier.justify(12_345, 5) }.must_raise(ArgumentError)
        err.message.must_equal('input should respond to chars, got 12345')
      end

      it 'raises on invalid n' do
        err = -> { Assignment::Justifier.justify('one two three', '5') }.must_raise(ArgumentError)
        err.message.must_equal('n should be an Integer, got "5"')
      end

      it 'raises on invalid version' do
        err = -> { Assignment::Justifier.justify('one two three', 5, 'v4') }.must_raise(ArgumentError)
        err.message.must_equal("version should be 'v1' or 'v2'")
      end
    end
  end
end
