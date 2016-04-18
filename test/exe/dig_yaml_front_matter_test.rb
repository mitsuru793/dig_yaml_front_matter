require_relative '../test_helper'

class DigYamlFrontMatterTest < Test::Unit::TestCase
  def create_files
    FileUtils.rm(Dir.glob('*'))
    create_memo('./file.md', title: 'file_title', tags: [])
    create_memo('./file_tag1.md', title: 'file_tag1_title', tags: ['tag1'])
    create_memo('./file_tag1_tag2.md', title: 'file_tag1_tag2_title', tags: ['tag1', 'tag2'])
    create_memo('./file_tag2.md', title: 'file_tag2_title', tags: ['tag2'])
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

  test "ls property" do
    create_files
    create_memo('./file_tag3.md',  title: 'file_tag3_title', tags: ['tag3'])
    out = capture_output { Command.start(%w{ls -e tags tag3 -p tags}) }[0]
    assert_equal out.split("\n"), ['[]', '["tag1"]', '["tag1", "tag2"]', '["tag2"]']

    out = capture_output { Command.start(%w{ls -e tags tag3 -p title}) }[0]
    expected = %w{file_title file_tag1_title file_tag1_tag2_title file_tag2_title}
    assert_equal out.split("\n"), expected
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

  test "count day average" do
    memo_num = create_memos_with_date_title
    out = capture_output { Command.start(%w{count -e day -a}) }[0]
    assert_equal out.to_f, memo_num / 3.0
  end

  test "count month average" do
    memo_num = create_memos_with_date_title
    out = capture_output { Command.start(%w{count -e month -a}) }[0]
    assert_equal out.to_f, memo_num / 2.0
  end

  test "count year average" do
    memo_num = create_memos_with_date_title
    out = capture_output { Command.start(%w{count -e year -a}) }[0]
    assert_equal out.to_f, memo_num / 2.0
  end

  test "count wday average" do
    memo_num = create_memos_with_date_title
    out = capture_output { Command.start(%w{count -e wday -a}) }[0]
    assert_equal out.to_f, memo_num / 7.0
  end
end
