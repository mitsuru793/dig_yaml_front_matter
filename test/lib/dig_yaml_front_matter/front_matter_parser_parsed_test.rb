require_relative '../../test_helper'

class FrontMatterParserParsedTest < Test::Unit::TestCase
  using DigYamlFrontMatter
  def setup
    @digger = DigYamlFrontMatter::Digger.new
  end

  def teardown
    FileUtils.rm_rf('/tmp')
  end

  sub_test_case "include_all?" do
    test "checks array" do
      create_memo('/tmp/tag123.md', tags: ['tag1', 'tag2'])
      parsed = @digger.parse('/tmp/tag123.md')
      assert_true parsed.include_all?(tags: ['tag1'])
      assert_true parsed.include_all?(tags: ['tag1', 'tag2'])
      assert_false parsed.include_all?(tags: ['tag1', 'tag3'])
    end

    test "checks string" do
      create_memo('/tmp/tag123.md', title: "hello world")
      parsed = @digger.parse('/tmp/tag123.md')
      assert_true parsed.include_all?(title: ['hello', 'world'])
      assert_true parsed.include_all?(title: ['world'])
      assert_false parsed.include_all?(title: ['Hi, everyone!', 'hello world'])
    end

    test "returns false when empty" do
      create_memo('/tmp/tag123.md', tags: [])
      parsed = @digger.parse('/tmp/tag123.md')
      assert_false parsed.include_all?(tags: ['tag1'])
    end
  end

  sub_test_case "include_any?" do
    test "checks array" do
      create_memo('/tmp/tag123.md', tags: ['tag1', 'tag2'])
      parsed = @digger.parse('/tmp/tag123.md')
      assert_true parsed.include_any?(tags: ['tag1'])
      assert_true parsed.include_any?(tags: ['tag2', 'tag3'])
      assert_false parsed.include_any?(tags: ['tag3', 'tag4'])
    end

    test "checks string" do
      create_memo('/tmp/tag123.md', title: "hello world")
      parsed = @digger.parse('/tmp/tag123.md')
      assert_true parsed.include_any?(title: ['Hi, everyone!', 'hello world'])
      assert_true parsed.include_any?(title: ['world'])
      assert_false parsed.include_any?(title: ['word', 'HELO'])
    end

    test "returns false when empty" do
      create_memo('/tmp/tag123.md', tags: [])
      parsed = @digger.parse('/tmp/tag123.md')
      assert_false parsed.include_any?(tags: ['tag1'])
    end
  end
end
