# frozen_string_literal: true

require_relative "heroicons_helper/version"
require_relative "heroicons_helper/cache"
require_relative "heroicons_helper/icon"
require "json"

module HeroiconsHelper
  file_data = File.read(File.join(File.dirname(__FILE__), "./heroicons_helper/data.json"))
  ICON_NAMES = JSON.parse(file_data).freeze

  def heroicon(name, variant:, **attributes)
    ::HeroiconsHelper::Icon.new(name, variant, attributes: attributes)
  end
end
