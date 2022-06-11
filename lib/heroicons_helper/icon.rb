# frozen_string_literal: true

module HeroiconsHelper
  # Icon to show heroicons by name and variant.
  class Icon
    attr_reader :path, :attributes, :width, :height, :symbol, :variant, :keywords

    VARIANT_OUTLINE = "outline"
    VARIANT_SOLID = "solid"
    VARIANTS = [VARIANT_OUTLINE, VARIANT_SOLID].freeze

    def initialize(symbol, variant, attributes: {})
      @symbol = symbol.to_s
      @variant = variant.to_s

      heroicon = get_heroicon(@symbol, @variant)

      @path = heroicon["path"]
      @width = heroicon["width"]
      @height = heroicon["height"]
      @keywords = heroicon["keywords"]
      @attributes = attributes.dup
      @attributes[:class] = classes
      @attributes[:viewBox] = viewbox
      @attributes.merge!(size)
      @attributes[:version] = "1.1"
      @attributes.merge!(variant_attributes)
      @attributes.merge!(a11y)
    end

    # Returns an string representing a <svg> tag
    def to_svg
      "<svg xmlns=\"http://www.w3.org/2000/svg\" #{html_attributes}>#{@path}</svg>"
    end

    private def html_attributes
      attrs = []
      @attributes.each_pair { |attr, value| attrs << "#{attr}=\"#{value}\"" }
      attrs.map(&:strip).join(" ")
    end

    # add some accessibility features to svg
    private def a11y
      accessible = {}

      if @attributes[:"aria-label"].nil? && @attributes["aria-label"].nil?
        accessible[:"aria-hidden"] = "true"
      else
        accessible[:role] = "img"
      end

      accessible
    end

    # prepare the octicon class
    private def classes
      "heroicon heroicon-#{@symbol}-#{@variant} #{@attributes[:class]} ".strip
    end

    private def variant_attributes
      case @variant
      when VARIANT_OUTLINE
        {
          fill: "none",
          stroke: "currentColor",
        }
      when VARIANT_SOLID
        {
          fill: "currentColor",
        }
      end
    end

    private def viewbox
      "0 0 #{@width} #{@height}"
    end

    # determine the height and width of the octicon based on :size option
    private def size
      size = {
        width: @width,
        height: @height,
      }

      # Specific size
      unless @attributes[:width].nil? && @attributes[:height].nil?
        size[:width]  = @attributes[:width].nil? ? calculate_width(@attributes[:height]) : @attributes[:width]
        size[:height] = @attributes[:height].nil? ? calculate_height(@attributes[:width]) : @attributes[:height]
        @width = size[:width]
        @height = size[:height]
      end

      size
    end

    private def calculate_width(height)
      (height.to_i * @width) / @height
    end

    private def calculate_height(width)
      (width.to_i * @height) / @width
    end

    private def get_heroicon(symbol, variant)
      raise ArgumentError, "Icon name can't be empty" if symbol.empty?

      raise ArgumentError, "Variant `#{variant.inspect}` is invalid; must be one of #{VARIANTS.join(", ")}" unless VARIANTS.include?(variant)

      icon = HeroiconsHelper::ICON_SYMBOLS[symbol]

      raise ArgumentError, "Couldn't find Heroicon for `#{symbol.inspect}`" unless icon

      icon_variant = icon["variants"][variant]
      raise ArgumentError, "Heroicon for `#{symbol.inspect}` doesn't have variant `#{variant.inspect}`" unless icon_variant

      {
        "name" => icon["name"],
        "variant" => variant,
        "keywords" => icon["keywords"] || [],
        "width" => icon_variant["width"],
        "height" => icon_variant["height"],
        "path" => icon_variant["path"],
      }
    end
  end
end
