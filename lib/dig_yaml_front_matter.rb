require 'front_matter_parser'

require 'dig_yaml_front_matter/version'
require 'dig_yaml_front_matter/front_matter_parser_parsed'
require 'array'
require 'string'

module DigYamlFrontMatter
  class Digger
    def parse(path)
      FrontMatterParser.parse_file(path)
    end

    def dig(glob, &block)
      parseds = []
      Dir.glob(glob).each do |path|
        parsed = parse(path)
        parsed = yield(path, parsed) if block_given?
        parseds << parsed if parsed
      end
      parseds
    end
  end
end
