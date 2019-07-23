require 'json'
require 'yaml'

module Assignment
  module TreeBuilder
    extend self

    def build_tree(data)
      res = {}
      data.each do |k, v|
        set(res, k, v)
      end

      res
    end

    def convert_and_save(in_file, out_file)
      raw_data = YAML.load_file(in_file)
      prettified_data = JSON.parse(JSON.pretty_generate(raw_data))
      res = build_tree(prettified_data).to_yaml
      File.write(out_file, res)
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
  end
end
