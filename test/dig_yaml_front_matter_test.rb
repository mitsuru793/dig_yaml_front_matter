require_relative 'test_helper'

class DigYamlFrontMatterTest < Test::Unit::TestCase
  def setup
    @digger = DigYamlFrontMatter::Digger.new
  end

  def teardown
    FileUtils.rm_rf('/tmp')
  end

  sub_test_case "#parse" do
    test "returns parsed object" do
      parse = {
        title:      'Hello World',
        date:       '2016-03-24 02:16',
        tags:       ['tag1', 'tag2'],
        categories: ['cate1', 'cate2'],
        content:    "hello hello"
      }
      create_memo('/tmp/hello.md', parse)
      target = @digger.parse('/tmp/hello.md')
      assert_equal target.front_matter, parse.select {|k, v| k != 'content'}
      assert_equal target.content.chomp, parse['content']
    end
  end

  sub_test_case "#dig" do
    def assert_parse (parsed, i)
      assert_equal parsed['title'], "hello#{i}"
      assert_equal parsed['date'], "2016-01-01 0#{i}:00"
      assert_equal parsed['tags'], "tag#{i}"
      assert_equal parsed['categories'], "category#{i}"
    end

    test "passed digging results to block and returns them" do
      create_number = 3
      create_memos('/tmp/hello.md', create_number)
      i = 0
      parseds = @digger.dig("/tmp/*.md") { |path, parsed|
        assert_equal path, "/tmp/hello#{i}.md"
        assert_parse(parsed, i)
        i += 1
        parsed
      }
      assert_equal parseds.size, create_number
      parseds.each_with_index do |parsed, i|
        assert_parse(parsed, i)
      end
    end

    test "returns digging result without block" do
      create_number = 5
      create_memos('/tmp/hello.md', create_number)
      parseds = @digger.dig("/tmp/*.md")
      assert_equal parseds.size, create_number
      parseds.each_with_index do |parsed, i|
        assert_parse(parsed, i)
      end
    end

    test "change parsed into what block returns" do
      create_memos('/tmp/hello.md', 1)
      create_memos('/tmp/hello.md', 2)
      parseds = @digger.dig("/tmp/*.md") do
        "hello"
      end
      assert_equal parseds[0], "hello"
      assert_equal parseds[1], "hello"
    end
  end
end
