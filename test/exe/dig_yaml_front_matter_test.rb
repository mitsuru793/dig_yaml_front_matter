require_relative '../test_helper'

class DigYamlFrontMatterTest < Test::Unit::TestCase
  def create_files
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
end
