# DigYamlFrontMatter

YAML Front Matterをフィルターにして、ファイル検索が行えます。

## Usage
### ls

フィルターに引っかかったファイルの相対パスを列挙します。第1引数に指定したYaml Front Matterのプロパティ名が検索対象になります。

検索場所のパスはglobで指定可能です。デフォルトの検索場所は、カレントディレクトリです。

#### OR検索
```
# tagsにgame, dragonのどちらかが含まれているファイルを検索
dig_yaml_front_matter ls -i tags game dragon

# titleに「について」と「何」のどちらかが含まれているファイルを検索
dig_yaml_front_matter ls -i title について 何

# tagsにgame, dragonのどちらかが含まれているファイルを検索
dig_yaml_front_matter ls -E tags game dragon
```

#### AND検索
```
# tagsにgame, dragonの両方が含まれているファイルを検索
dig_yaml_front_matter ls -I tags game dragon

# titleに「について」と「何」の両方が含まれているファイルを検索
dig_yaml_front_matter ls -I title について 何

# tagsにgameの両方が含まれていファイルを検索
dig_yaml_front_matter ls -E tags game
```

#### 検索場所の変更
```
# ./blog/にあるmdファイルからファイルを検索
dig_yaml_front_matter ls --path='./blog/**.md'
```

### count

日・月・年・曜日別でファイルを集計できます。`each`オプションで集計単位を指定します。`average`オプションを一緒に使うと平均が取れます。

| 単位 | オプション値 |
|:-----|:-------------|
| 日   | day          |
| 月   | month        |
| 年   | year         |
| 曜日 | wday         |

検索場所のパスはglobで指定可能です。デフォルトの検索場所は、カレントディレクトリです。オプション値は`ls`と同じ`--path`です。

```
❯ dig_yaml_front_matter count -e date
2016-03-22 Tue [16]
2016-03-23 Wed [11]
2016-03-24 Thu [2]

> dig_yaml_front_matter count -e wday
Sun [11]
Mon [3]
Tue [22]

❯ dig_yaml_front_matter count -e day -a
5.7272727272727275
```

作成日の判定はファイル名です。接頭辞が`%y-%m-%d`になっている必要があります。

| ファイル名           | 可否             |
|:---------------------|:-----------------|
| 2016-03-21-file.md   | ○                |
| 2016-03-21_file.md   | ○                |
| 16-03-21_file.md     | ☓                |
| 16-3-21_file.md      | ☓                |

## Install

```
git clone https://github.com/mitsuru793/dig_yaml_front_matter
cd dig_yaml_front_matter
bundle install
bundle exec rake build
gem install pkg/dig_yaml_front_matter-0.1.0.gem
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dig_yaml_front_matter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
