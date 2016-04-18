#!/usr/bin/env ruby
require 'thor'
require 'front_matter_parser'
require 'awesome_print'
require 'dig_yaml_front_matter'

class Command < Thor
  using DigYamlFrontMatter
  desc 'ls', 'list file path filtering with item of yaml front matter'
  option :path, :default => './*.md'
  option :include_any, :aliases => '-i', :type => :array
  option :exclude_any, :aliases => '-e', :type => :array
  option :include_all, :aliases => '-I', :type => :array
  option :exclude_all, :aliases => '-E', :type => :array
  def ls
    digger = DigYamlFrontMatter::Digger.new
    digger.dig(options['path']) do |path, parsed|
      is_pass = false
      filter_modes = ['include_any', 'exclude_any', 'include_all', 'exclude_all']
      filter_modes.each do |mode|
        if options[mode] and options[mode].size < 2
          puts "#{mode} option requires arguments more than 2."
          exit
        elsif options[mode] and options[mode].size > 1
          item_name = options[mode][0]
          next unless parsed.front_matter.has_key?(item_name)
          case mode
          when 'include_any'
            is_pass = parsed.include_any?(item_name => options[mode][1..-1])
          when 'exclude_any'
            is_pass = !parsed.include_any?(item_name => options[mode][1..-1])
          when 'include_all'
            is_pass = parsed.include_all?(item_name => options[mode][1..-1])
          when 'exclude_all'
            is_pass = !parsed.include_all?(item_name => options[mode][1..-1])
          end
          break unless is_pass
        end
      end
      is_pass = true if filter_modes.all? { |m| options[m].nil? }
      puts path if is_pass
    end
  end
end

Command.start(ARGV)
