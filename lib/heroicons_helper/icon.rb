# frozen_string_literal: true

module HeroiconsHelper
  # Icon to show heroicons by name and variant.
  class Icon
    attr_reader :path, :attributes, :width, :height, :symbol, :variant

    VARIANT_OUTLINE = "outline"
    VARIANT_SOLID = "solid"
    VARIANTS = [VARIANT_OUTLINE, VARIANT_SOLID].freeze

    def initialize(symbol, variant, attributes: {})
      @symbol = symbol
      @variant = variant

      icon = get_heroicon(@symbol, @variant)

      @path = icon["path"]
      @width = icon["width"]
      @height = icon["height"]
      @attributes = attributes.dup.merge!(default_attributes)
    end

    # Returns an string representing a <svg> tag
    def to_svg
      "<svg xmlns=\"http://www.w3.org/2000/svg\" #{html_attributes}>#{@path}</svg>"
    end

    private

    def html_attributes
      attrs = []
      @attributes.each_pair { |attr, value| attrs << "#{attr}=\"#{value}\"" }
      attrs.map(&:strip).join(" ")
    end

    def default_attributes
      case @variant
      when VARIANT_OUTLINE
        {
          viewBox: viewbox,
          fill: "none",
          stroke: "currentColor",
        }
      when VARIANT_SOLID
        {
          viewBox: viewbox,
          fill: "currentColor",
        }
      end
    end

    def viewbox
      "0 0 #{@width} #{@height}"
    end

    def get_heroicon(symbol, variant)
      raise ArgumentError, "Icon name can't be empty" unless !symbol.to_s.empty?
      raise ArgumentError, "Variant `#{variant}` is invalid; must be one of #{VARIANTS.join(", ")}" unless VARIANTS.include?(variant.to_s)

      icon = HeroiconsHelper::ICON_SYMBOLS[symbol]

      raise ArgumentError, "Couldn't find Heroicon for `#{symbol.inspect}`" unless icon

      icon_in_variant = icon["variants"][variant]
      raise ArgumentError, "Heroicon for `#{symbol.inspect}` doesn't have variant `#{variant.inspect}`" unless icon_in_variant

      {
        "name" => icon["name"],
        "variant" => variant,
        "width" => icon_in_variant["width"],
        "height" => icon_in_variant["height"],
        "path" => icon_in_variant["path"],
      }
    end
  end
end
