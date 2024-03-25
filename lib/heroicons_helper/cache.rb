# frozen_string_literal: true

module HeroiconsHelper
  # :nodoc:
  class Cache
    LOOKUP = {}

    class << self
      def get_key(name:, variant:, **attributes)
        attrs = { name: name, variant: variant }.merge(attributes)

        attrs.compact!
        attrs.hash
      end

      def read(key)
        LOOKUP[key]
      end

      # Cache size limit.
      def limit
        500
      end

      def set(key, value)
        LOOKUP[key] = value

        # Remove first item when the cache is too large.
        LOOKUP.shift if LOOKUP.size > limit
      end

      def clear!
        LOOKUP.clear
      end

      # @param icons_to_preload [Array<Hash>] List of icons to render, in the format { name: :icon_name, variant: "variant" }.
      def preload!(icons_to_preload, &block)
        raise ArgumentError, "icons_to_preload must be an Array; it's #{icons_to_preload.class}" unless icons_to_preload.is_a?(Array)
        raise ArgumentError, "icons_to_preload must have between 1 and 20 items; you have #{preload.count}" unless (1..20).cover?(icons_to_preload.count)

        icons_to_preload.each do |icon|
          height = icon["height"] || nil
          width = icon["width"] || nil

          # Don't allow sizes under 16px
          if !height.nil? && height.to_i < 16
            height = nil
          end
          if !width.nil? && width.to_i < 16
            width = nil
          end

          cache_key = HeroiconsHelper::Cache.get_key(
            name: icon["name"],
            variant: icon["variant"],
            height: height,
            width: width,
          )

          cache_icon = HeroiconsHelper::Cache.read(cache_key)
          found = !cache_icon.nil?

          result = yield found, cache_icon || icon

          HeroiconsHelper::Cache.set(cache_key, result) unless found
        end
      end
    end
  end
end
