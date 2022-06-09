# HeroiconsHelper

This gem helps you use Heroicons in your Ruby projects. It's inspired by [heroicons-ruby](https://github.com/chunlea/heroicons-ruby) and [octicons](https://github.com/primer/octicons).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add heroicons_helper

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install heroicons_helper

## Usage

This gem is super simple! Require the gem, and include the module:

```ruby
require "heroicons_helper"

include HeroiconsHelper
```

You'll have a brand new method called `heroicons` whose signature looks like this:

```ruby
heroicons(symbol, variant, attributes: {})
```

where

* `symbol` is the heroicons name
* `variant` is the type of Heroicons (eg., `outline` or `solid`)
* `attributes` are any additional HTML attributes to add on to the resulting `svg` element

This one method call returns an object that represents the Heroicon, and you should call `to_svg` to get the resulting SVG string:

```ruby
outline_icon = heroicons("x", "outline")
puts outline_icon.to_svg
```
```
=> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"></path></svg>
```

## Development

To update the Heroicons set:

1. Run `npm install`
2. Run `script/update_heroicons`
