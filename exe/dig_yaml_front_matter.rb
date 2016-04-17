#!/usr/bin/env ruby
require 'thor'
require 'front_matter_parser'
require 'awesome_print'
require 'dig_yaml_front_matter'

class Command < Thor
  using DigYamlFrontMatter
  desc 'ls', 'list file path filtering with item of yaml front matter'
  option :path, :default => './*.md'
  option :include_all, :aliases => '-I', :type => :array
  option :exclude_all, :aliases => '-E', :type => :array
  def ls
    digger = DigYamlFrontMatter::Digger.new
    digger.dig(options['path']) do |path, parsed|
      is_pass = false
      ['include_all', 'exclude_all'].each do |mode|
        if options[mode] and options[mode].size < 2
          puts "#{mode} option requires arguments more than 2."
          exit
        elsif options[mode] and options[mode].size > 1
          item_name = options[mode][0]
          next unless parsed.front_matter.has_key?(item_name)
          case mode
          when 'include_all'
            is_pass = parsed.include_all?(item_name => options[mode][1..-1])
            break unless is_pass
          when 'exclude_all'
            is_pass = !parsed.include_all?(item_name => options[mode][1..-1])
            break unless is_pass
          end
        end
      end
      is_pass = true if options['include_all'].nil? and options['exclude_all'].nil?
      puts path if is_pass
    end
  end
end

Command.start(ARGV)
