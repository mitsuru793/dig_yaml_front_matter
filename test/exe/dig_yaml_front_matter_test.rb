require_relative '../test_helper'

class DigYamlFrontMatterTest < Test::Unit::TestCase
  test "ls all" do
    create_memo('./file.md',  tags: [])
    create_memo('./file_tag1.md',  tags: ['tag1'])
    create_memo('./file_tag1_tag2.md',  tags: ['tag1', 'tag2'])
    create_memo('./file_tag2.md',  tags: ['tag2'])

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
