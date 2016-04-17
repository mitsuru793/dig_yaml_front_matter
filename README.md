# DigYamlFrontMatter

YAML Front Matterをフィルターにして、ファイル検索が行えます。

```
# tagsにgame, dragonが含まれているファイルを検索
dig_yaml_front_matter ls -i tags game dragon

# ./blog/にあるmdファイルから、titleに「について」が含まれているファイルを検索
dig_yaml_front_matter ls --path='./blog/**.md' -i title について

# tagsにgameが含まれていファイルを検索
dig_yaml_front_matter ls -e tags game
```

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
