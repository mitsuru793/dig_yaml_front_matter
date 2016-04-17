module DigYamlFrontMatter
  refine String do
    def include_all?(other)
      other.all? {|other_value| include?(other_value)}
    end

    def include_any?(other)
      other.any? {|other_value| include?(other_value)}
    end
  end
end
