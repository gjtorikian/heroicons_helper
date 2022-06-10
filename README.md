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

You'll have a brand new method called `heroicon` whose signature looks like this:

```ruby
heroicon(symbol, variant, attributes: {})
```

where

* `symbol` is the heroicons name
* `variant` is the type of Heroicons (eg., `outline` or `solid`)
* `attributes` are any additional HTML attributes to add on to the resulting `svg` element

This one method call returns an object that represents the Heroicon, and you should call `to_svg` to get the resulting SVG string:

```ruby
outline_icon = heroicon("x", "outline")
puts outline_icon.to_svg
```
```
=> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"></path></svg>
```

## Cache

This gem also comes with a simple caching system, which can be useful to preload icons. It works like this:

``` ruby
icons_to_preload = [{
    name: "thumb-down",
    variant: "outline",
}, {
    name: "refresh",
    variant: "solid",
},]

HeroiconsHelper::Cache.preload!(icons_to_preload) do |found, icon|
    # An instance of `FakeClass` will be stored in the cache
    FakeClass.new(icon) unless found
end
```

`HeroiconsHelper::Cache.preload!` does one of two things:

* If, given the `icons_to_preload` array, an item is located in the cache, `found` is true and `icon` is the cached item
* Otherwise, `found` is false, and `icon` is the element currently being iterated. Also, the last line of the block sets the cache

The Hash elements within `icons_to_preload` can also take `height` and `width` keys.

## Development

To update the Heroicons set:

1. Run `npm install`
2. Run `script/update_heroicons`
