# frozen_string_literal: true

require "test_helper"

describe HeroiconsHelper::Icon do
  def setup
    HeroiconsHelper::Cache.clear!
  end

  it "initialize accepts a string for an icon name" do
    icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID)

    assert icon
  end

  it "initialize accepts a symbol for an icon name" do
    icon = heroicon(:"x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID)

    assert icon
  end

  it "the attributes are readable" do
    icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_OUTLINE)

    assert icon.inner
    assert icon.attributes
    assert_equal "x-mark", icon.name
    assert_equal "outline", icon.variant
    assert_equal 24, icon.width
    assert_equal 24, icon.height
  end

  it "gets keywords for the icon" do
    icon = heroicon("archive-box", variant: HeroiconsHelper::Icon::VARIANT_OUTLINE)

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
      heroicon("x-mark", "blarf")
    end

    assert_raises ArgumentError do
      heroicon("x-mark", 53)
    end

    assert_raises ArgumentError do
      heroicon("x-mark", [])
    end
  end

  describe "viewBox" do
    it "always has a viewBox" do
      outline_icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_OUTLINE)

      assert_includes outline_icon.to_svg, "viewBox=\"0 0 24 24\""

      solid_icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID)

      assert_includes solid_icon.to_svg, "viewBox=\"0 0 24 24\""

      mini_icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_MINI)

      assert_includes mini_icon.to_svg, "viewBox=\"0 0 20 20\""

      micro_icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_MICRO)

      assert_includes micro_icon.to_svg, "viewBox=\"0 0 16 16\""
    end
  end

  describe "html_attributes" do
    it "includes other html attributes" do
      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID, foo: "bar", disabled: "true")

      assert_includes icon.to_svg, "disabled=\"true\""
      assert_includes icon.to_svg, "foo=\"bar\""
    end

    it "ignores nil html attributes" do
      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID, foo: "bar", disabled: nil)

      refute_includes icon.to_svg, "disabled"
      assert_includes icon.to_svg, "foo=\"bar\""
    end

    it "accepts splatted html attributes" do
      attributes = { foo: "bar", disabled: "true" }
      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID, **attributes)

      assert_includes icon.to_svg, "disabled=\"true\""
      assert_includes icon.to_svg, "foo=\"bar\""
    end

    it "user does not get final say in some attribute values" do
      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_MINI)

      assert_includes icon.to_svg, "version=\"1.1\""

      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_MINI, attributes: { version: "4.20" })

      refute_includes icon.to_svg, "version=\"4.20\""
      assert_includes icon.to_svg, "version=\"1.1\""
    end
  end

  describe "classes" do
    it "includes classes passed in" do
      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_MICRO, class: "text-closed")

      assert_includes icon.to_svg, "class=\"heroicon heroicon-micro-x-mark text-closed\""
    end
  end

  describe "size" do
    it "always has width and height" do
      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID)

      assert_includes icon.to_svg, "height=\"24\""
      assert_includes icon.to_svg, "width=\"24\""

      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_MICRO)

      assert_includes icon.to_svg, "height=\"16\""
      assert_includes icon.to_svg, "width=\"16\""
    end

    it "accepts string size" do
      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID, size: "60")

      assert_includes icon.to_svg, "height=\"60\""
      assert_includes icon.to_svg, "width=\"60\""
    end

    it "accepts integer size" do
      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID, size: 60)

      assert_includes icon.to_svg, "height=\"60\""
      assert_includes icon.to_svg, "width=\"60\""
    end
  end

  describe "a11y" do
    it "includes attributes for symbol keys" do
      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID, "aria-label": "Close")

      assert_includes icon.to_svg, "role=\"img\""
      assert_includes icon.to_svg, "aria-label=\"Close\""
      refute_includes icon.to_svg, "aria-hidden"
    end

    it "includes attributes for string keys" do
      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID, "aria-label" => "Close")

      assert_includes icon.to_svg, "role=\"img\""
      assert_includes icon.to_svg, "aria-label=\"Close\""
      refute_includes icon.to_svg, "aria-hidden"
    end

    it "has aria-hidden when no label is passed in" do
      icon = heroicon("x-mark", variant: HeroiconsHelper::Icon::VARIANT_SOLID)

      assert_includes icon.to_svg, "aria-hidden=\"true\""
    end
  end
end
