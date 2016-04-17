DIR_NAME = File.dirname(__FILE__)
Dir[File.join(DIR_NAME, "../lib/**/*.rb")].each { |f| require f }
require_relative '../exe/dig_yaml_front_matter'
require 'test/unit'
require 'awesome_print'
require 'fakefs'
include DigYamlFrontMatter

def fixture_path(path)
  File.expand_path(File.join(DIR_NAME, '/fixtures/', path))
end

def create_memo(path, parse)
  str_keys =  parse.keys.map {|v| v.to_s}
  str_keys.each do |str_key|
    sym_key = str_key.to_sym
    if parse.has_key?(sym_key)
      parse[str_key] = parse[sym_key]
      parse.delete(sym_key)
    end
  end
  parse = {
    'title'      => "Hello",
    'date'       => DateTime.now.strftime("%Y-%m-%d %H:%M"),
    'tags'       => "",
    'categories' => ""
  }.merge(parse)

  content = <<-EOS
---
title: #{parse['title']}
date: #{parse['date']}
tags: #{parse['tags']}
categories: #{parse['categories']}
---
#{parse['content']}
  EOS
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, content)
end

def create_memos(path, number)
  title_suffix = File.basename(path, '.*')
  number.times do |i|
    parse = {
      'title'      => title_suffix + i.to_s,
      'date'       => "2016-01-01 0#{i}:00",
      'tags'       => "tag#{i}",
      'categories' => "category#{i}"
    }
    new_path = File.join(File.dirname(path), title_suffix + i.to_s + File.extname(path))
    create_memo(new_path, parse)
  end
end
