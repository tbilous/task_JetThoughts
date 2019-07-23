require 'minitest/autorun'
require_relative '../../lib/assignment/tree_builder'

def load_fixture(in_file)
  raw_data = YAML.load_file(in_file)
  JSON.parse(JSON.pretty_generate(raw_data))
end

describe 'Assignment::TreeBuilder' do
  before do
    @root = __dir__.split('/')[0..-3].join('/')
    @in_file = "#{@root}/test/fixtures/translations_simple.yml"
  end

  describe '#build_tree' do
    before do
      @valid_output = {
        'en' => {
          'pets' => {
            'types' => {
              'cat' => 'Cat',
              'dog' => 'Dog'
            },
            'title' => 'My lovely pets'
          },
          'actions' => {
            'add' => 'Add',
            'remove' => 'Remove'
          },
          'language' => '<strong>Language</strong>'
        }
      }
    end

    it 'should build a proper tree' do
      data = load_fixture(@in_file)
      Assignment::TreeBuilder.build_tree(data).must_equal(@valid_output)
    end
  end

  describe '#convert_and_save' do
    before do
      @out_file = "#{@root}/tmp/translations.yml"
      Assignment::TreeBuilder.convert_and_save(@in_file, @out_file)
    end

    after do
      File.delete(@out_file) if File.exist?(@out_file)
    end

    it 'must produce valid YAML output file' do
      data = load_fixture(@in_file)
      res = Assignment::TreeBuilder.build_tree(data)

      YAML.load_file(@out_file).must_equal(res)
    end
  end
end
