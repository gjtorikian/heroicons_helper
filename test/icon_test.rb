# frozen_string_literal: true

require "test_helper"

describe HeroiconsHelper::Icon do
  it "fails when the icon not exists in heroicons" do
    assert_raises(RuntimeError) do
      heroicons(:not_exist, "outline")
    end
  end

  it "initialize accepts a string for an icon with variant" do
    icon = heroicons("x", "outline")
    assert icon
  end

  it "the attributes are readable" do
    icon = heroicons("x", "outline")
    assert icon.path
    assert icon.attributes
    assert_equal "x", icon.symbol
    assert_equal "outline", icon.variant
    assert_equal 24, icon.width
    assert_equal 24, icon.height
  end

  describe "viewBox" do
    it "always has a viewBox" do
      outline_icon = heroicons("x", "outline")
      assert_includes outline_icon.to_svg, "viewBox=\"0 0 24 24\""
      solid_icon = heroicons("x", "solid")
      assert_includes solid_icon.to_svg, "viewBox=\"0 0 20 20\""
    end
  end

  describe "html_attributes" do
    it "includes other html attributes" do
      icon = heroicons("x", "solid", attributes: { class: "class1 class2", foo: "bar", disabled: "true" })
      assert_includes icon.to_svg, "class=\"class1 class2\""
      assert_includes icon.to_svg, "disabled=\"true\""
      assert_includes icon.to_svg, "foo=\"bar\""
    end
  end
end
