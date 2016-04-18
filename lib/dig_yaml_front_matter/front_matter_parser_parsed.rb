require 'front_matter_parser'

module DigYamlFrontMatter
  refine FrontMatterParser::Parsed do
    def include_all?(other_hash)
      other_hash.each do |key, other_value|
        key = key.to_s if key.kind_of?(Symbol)
        front_value = @front_matter[key]
        return false if front_value.nil?
        case front_value
        when *[Array, String]
          [].include_all?(other_value)
          return front_value.include_all?(other_value)
        else
          return false
        end
      end
    end

    def include_any?(other_hash)
      other_hash.each do |key, other_value|
        key = key.to_s if key.kind_of?(Symbol)
        front_value = @front_matter[key]
        return false if front_value.nil?
        case front_value
        when *[Array, String]
          return front_value.include_any?(other_value)
        else
          return false
        end
      end
    end
  end
end
