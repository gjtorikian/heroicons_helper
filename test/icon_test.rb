# frozen_string_literal: true

require "test_helper"

describe HeroiconsHelper::Icon do
  def setup
    HeroiconsHelper::Cache.clear!
  end

  it "initialize accepts a string for an icon name" do
    icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID)
    assert icon
  end

  it "initialize accepts a symbol for an icon name" do
    icon = heroicon(:x, variant: HeroiconsHelper::Icon::VARIANT_SOLID)
    assert icon
  end

  it "the attributes are readable" do
    icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_OUTLINE)
    assert icon.path
    assert icon.attributes
    assert_equal "x", icon.name
    assert_equal "outline", icon.variant
    assert_equal 24, icon.width
    assert_equal 24, icon.height
  end

  it "gets keywords for the icon" do
    icon = heroicon("archive", variant: HeroiconsHelper::Icon::VARIANT_OUTLINE)
    assert_equal ["box", "catalog"], icon.keywords
  end

  it "errors on invalid name" do
    assert_raises ArgumentError do
      heroicon(:not_exist, variant: HeroiconsHelper::Icon::VARIANT_OUTLINE)
    end

    assert_raises ArgumentError do
      heroicon(nil, variant: HeroiconsHelper::Icon::VARIANT_SOLID)
    end

    assert_raises ArgumentError do
      heroicon(25, variant: HeroiconsHelper::Icon::VARIANT_SOLID)
    end
    assert_raises ArgumentError do
      refute heroicon([], variant: HeroiconsHelper::Icon::VARIANT_SOLID)
    end
  end

  it "errors on invalid variant" do
    assert_raises ArgumentError do
      heroicon("x", "blarf")
    end

    assert_raises ArgumentError do
      heroicon("x", 53)
    end

    assert_raises ArgumentError do
      heroicon("x", [])
    end
  end

  describe "viewBox" do
    it "always has a viewBox" do
      outline_icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_OUTLINE)
      assert_includes outline_icon.to_svg, "viewBox=\"0 0 24 24\""
      assert_includes outline_icon.to_svg, "fill=\"none\""
      assert_includes outline_icon.to_svg, "stroke=\"currentColor\""
      solid_icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID)
      assert_includes solid_icon.to_svg, "viewBox=\"0 0 20 20\""
      assert_includes solid_icon.to_svg, "fill=\"currentColor\""
    end
  end

  describe "html_attributes" do
    it "includes other html attributes" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, foo: "bar", disabled: "true")
      assert_includes icon.to_svg, "disabled=\"true\""
      assert_includes icon.to_svg, "foo=\"bar\""
    end

    it "ignores nil html attributes" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, foo: "bar", disabled: nil)
      refute_includes icon.to_svg, "disabled"
      assert_includes icon.to_svg, "foo=\"bar\""
    end

    it "accepts splatted html attributes" do
      attributes = { foo: "bar", disabled: "true" }
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, **attributes)
      assert_includes icon.to_svg, "disabled=\"true\""
      assert_includes icon.to_svg, "foo=\"bar\""
    end
  end

  describe "classes" do
    it "includes classes passed in" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, class: "text-closed")
      assert_includes icon.to_svg, "class=\"heroicon heroicon-x-solid text-closed\""
    end
  end

  describe "comments" do
    it "includes variant and icon passed in" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, class: "text-closed")
      assert_includes icon.to_svg, "<!-- Heroicon name: solid/x -->"

      icon = heroicon(:"at-symbol", variant: HeroiconsHelper::Icon::VARIANT_OUTLINE, class: "text-closed")
      assert_includes icon.to_svg, "<!-- Heroicon name: outline/at-symbol -->"
    end
  end

  describe "size" do
    it "always has width and height" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID)
      assert_includes icon.to_svg, "height=\"20\""
      assert_includes icon.to_svg, "width=\"20\""
    end

    it "converts number string height to integer" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, height: "60")
      assert_includes icon.to_svg, "height=\"60\""
      assert_includes icon.to_svg, "width=\"60\""
    end

    it "converts number height to integer" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, height: 60)
      assert_includes icon.to_svg, "height=\"60\""
      assert_includes icon.to_svg, "width=\"60\""
    end

    it "converts number string width to integer" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, width: "45")
      assert_includes icon.to_svg, "height=\"45\""
      assert_includes icon.to_svg, "width=\"45\""
    end

    it "converts number width to integer" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, width: 45)
      assert_includes icon.to_svg, "height=\"45\""
      assert_includes icon.to_svg, "width=\"45\""
    end

    it "with height and width passed in" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, width: 60, height: 60)
      assert_includes icon.to_svg, "width=\"60\""
      assert_includes icon.to_svg, "height=\"60\""
    end

    it "chooses the correct svg given a height" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, height: 32)
      assert_includes icon.to_svg, "width=\"32\""
      assert_includes icon.to_svg, "height=\"32\""
      assert_includes icon.to_svg, "viewBox=\"0 0 20 20\""
    end

    it "chooses the correct svg given a width" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, width: 48)
      assert_includes icon.to_svg, "width=\"48\""
      assert_includes icon.to_svg, "height=\"48\""
      assert_includes icon.to_svg, "viewBox=\"0 0 20 20\""
    end

    it "chooses the correct svg given a height and width" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, height: 24, width: 16)
      assert_includes icon.to_svg, "width=\"16\""
      assert_includes icon.to_svg, "height=\"24\""
      assert_includes icon.to_svg, "viewBox=\"0 0 20 20\""
    end
  end

  describe "a11y" do
    it "includes attributes for symbol keys" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, "aria-label": "Close")
      assert_includes icon.to_svg, "role=\"img\""
      assert_includes icon.to_svg, "aria-label=\"Close\""
      refute_includes icon.to_svg, "aria-hidden"
    end

    it "includes attributes for string keys" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID, "aria-label" => "Close")
      assert_includes icon.to_svg, "role=\"img\""
      assert_includes icon.to_svg, "aria-label=\"Close\""
      refute_includes icon.to_svg, "aria-hidden"
    end

    it "has aria-hidden when no label is passed in" do
      icon = heroicon("x", variant: HeroiconsHelper::Icon::VARIANT_SOLID)
      assert_includes icon.to_svg, "aria-hidden=\"true\""
    end
  end
end
