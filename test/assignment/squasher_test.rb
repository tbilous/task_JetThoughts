require 'minitest/autorun'
require_relative '../../lib/assignment/squasher'

describe 'Assignment::Squasher' do
  describe '#squash' do
    it 'must squash ascending sequences' do
      Assignment::Squasher.squash('xyz').must_equal('x-z')
    end

    it 'must squash descending sequences' do
      Assignment::Squasher.squash('fedcba').must_equal('f-a')
    end

    it 'must properly squash sample string' do
      Assignment::Squasher.squash('abcdab987612').must_equal('a-dab9-612')
    end

    it 'raises on invalid input' do
      err = -> { Assignment::Squasher.squash(12_345) }.must_raise(ArgumentError)
      err.message.must_equal('input should respond to chars, got 12345')
    end
  end
end
