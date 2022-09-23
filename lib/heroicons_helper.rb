# frozen_string_literal: true

require_relative "heroicons_helper/version"
require_relative "heroicons_helper/cache"
require_relative "heroicons_helper/icon"
require "json"

module HeroiconsHelper
  file_data = File.read(File.join(File.dirname(__FILE__), "./heroicons_helper/data.json"))
  ICON_NAMES = JSON.parse(file_data).freeze

  def heroicon(name, variant:, unsafe: false, **attributes)
    cache_key = HeroiconsHelper::Cache.get_key(
      name: name,
      variant: variant,
      unsafe: unsafe,
      height: attributes[:height],
      width: attributes[:width],
    )

    cached_heroicon = HeroiconsHelper::Cache.read(cache_key)
    return cached_heroicon unless cached_heroicon.nil?

    heroicon = ::HeroiconsHelper::Icon.new(name, variant, unsafe: unsafe, attributes: attributes)
    HeroiconsHelper::Cache.set(cache_key, heroicon)

    heroicon
  end
end
