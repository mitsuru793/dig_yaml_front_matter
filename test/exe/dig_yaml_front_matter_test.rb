require_relative '../test_helper'

class DigYamlFrontMatterTest < Test::Unit::TestCase
  def create_files
    FileUtils.rm(Dir.glob('*'))
    create_memo('./file.md',  tags: [])
    create_memo('./file_tag1.md',  tags: ['tag1'])
    create_memo('./file_tag1_tag2.md',  tags: ['tag1', 'tag2'])
    create_memo('./file_tag2.md',  tags: ['tag2'])
  end

  test "ls any" do
    create_files
    out = capture_output { Command.start(%w{ls -I tags tag1}) }[0]
    assert_equal out.split("\n"), %w{/file_tag1.md /file_tag1_tag2.md}

    out = capture_output { Command.start(%w{ls -i tags tag1 tag2}) }[0]
    assert_equal out.split("\n"), %w{/file_tag1.md /file_tag1_tag2.md /file_tag2.md}

    out = capture_output { Command.start(%w{ls -e tags tag1}) }[0]
    assert_equal out.split("\n"), %w{/file.md /file_tag2.md}

    out = capture_output { Command.start(%w{ls -e tags tag1 tag2}) }[0]
    assert_equal out.split("\n"), %w{/file.md}

    out = capture_output { Command.start(%w{ls -i tags tag1 -e tags tag2}) }[0]
    assert_equal out.split("\n"), %w{/file_tag1.md}
  end

  test "ls all" do
    create_files
    out = capture_output { Command.start(%w{ls -I tags tag1}) }[0]
    assert_equal out.split("\n"), %w{/file_tag1.md /file_tag1_tag2.md}

    out = capture_output { Command.start(%w{ls -I tags tag1 tag2}) }[0]
    assert_equal out.split("\n"), %w{/file_tag1_tag2.md}

    out = capture_output { Command.start(%w{ls -E tags tag1}) }[0]
    assert_equal out.split("\n"), %w{/file.md /file_tag2.md}

    out = capture_output { Command.start(%w{ls -E tags tag1 tag2}) }[0]
    assert_equal out.split("\n"), %w{/file.md /file_tag1.md /file_tag2.md}

    out = capture_output { Command.start(%w{ls -I tags tag1 -E tags tag2}) }[0]
    assert_equal out.split("\n"), %w{/file_tag1.md}
  end

  def create_memos_with_date_title
    FileUtils.rm(Dir.glob('*'))
    dates = %w{1992-03-27 1992-03-27 1992-03-28 2016-04-22}
    dates.each_with_index do |d, i|
      create_memo("./#{d}-file#{i}.md")
    end
    dates.length
  end

  test "count each date" do
    expected = ['1992-03-27 Fri [2]', '1992-03-28 Sat [1]', '2016-04-22 Fri [1]']
    create_memos_with_date_title
    out = capture_output { Command.start(%w{count -e day}) }[0]
    assert_equal out.split("\n"), expected
  end

  test "count each month" do
    expected = ['1992-03 [3]', '2016-04 [1]']
    create_memos_with_date_title
    out = capture_output { Command.start(%w{count -e month}) }[0]
    assert_equal out.split("\n"), expected
  end

  test "count each year" do
    expected = ['1992 [3]', '2016 [1]']
    create_memos_with_date_title
    out = capture_output { Command.start(%w{count -e year}) }[0]
    assert_equal out.split("\n"), expected
  end

  test "count each day of the week" do
    expected = ['Fri [3]', 'Sat [1]']
    create_memos_with_date_title
    out = capture_output { Command.start(%w{count -e wday}) }[0]
    assert_equal out.split("\n"), expected
  end
end
