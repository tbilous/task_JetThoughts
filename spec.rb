require 'minitest/autorun'
require_relative 'tasks'

class YamlLint
  def initialize(file)
    @file = file
  end

  def parse_file
    unless File.extname(@file) =~ /.(yaml|yml)$/
      return 1
    end
    begin
      YAML.load_file(@file)
    rescue StandardError
      return 1
    else
      return 0
    end
  end
end

describe 'Tasks::PartOneTaskOne'  do
  it { Tasks::PartOneTaskOne.new('abcdab987612').squash.must_equal 'a-dab9-612' }
end

describe 'Tasks::PartOneTaskTwo' do
  %w[v1 v2].each do |config|
    it "config: #{config}" do
      Tasks::PartOneTaskTwo.new('To be or not to be that is the question', 5, config)
          .justify.must_equal "To be\nor\nnot\nto be\nthat\nis\nthe\nquest\nion"
    end
  end
end

describe 'Tasks::PartTwo' do
  before { Tasks::PartTwo.new.convert }
  it { YamlLint.new('translations.yml').parse_file.must_equal 0 }
end