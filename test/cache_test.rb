# frozen_string_literal: true

require "test_helper"

module HeroiconsHelper
  class CacheTest < Minitest::Test
    class FakeClass
      attr_reader :icon

      def initialize(icon)
        @icon = icon
      end
    end

    def setup
      @data = JSON.parse(File.read(File.join(File.dirname(__FILE__), "../lib/heroicons_helper/data.json")))
      @empty_data = []

      @few_data = @data.to_a.sample(5).map { |d| d[1] }
      @twenty_data = @data.to_a.sample(20).map { |d| d[1] }
    end

    def test_preload_loads_heroicon_cache
      HeroiconsHelper::Cache.clear!

      assert_empty(HeroiconsHelper::Cache::LOOKUP)

      HeroiconsHelper::Cache.preload!(@few_data) do |found, icon|
        FakeClass.new(icon) unless found
      end

      assert_equal(5, HeroiconsHelper::Cache::LOOKUP.size)
    end

    def test_clear_clears_the_cache
      HeroiconsHelper::Cache.clear!

      assert_empty(HeroiconsHelper::Cache::LOOKUP)
    end

    def test_get_key_returns_the_correct_key
      assert_equal({ name: :alert, variant: :solid }.hash, HeroiconsHelper::Cache.get_key(name: :alert, variant: :solid))
      assert_equal({ name: :alert, variant: :outline }.hash, HeroiconsHelper::Cache.get_key(name: :alert, variant: :outline))
      assert_equal({ name: :alert, variant: :mini }.hash, HeroiconsHelper::Cache.get_key(name: :alert, variant: :mini))
      assert_equal({ name: :alert, variant: :micro }.hash, HeroiconsHelper::Cache.get_key(name: :alert, variant: :micro))
    end

    def test_does_not_duplicate_cached_items
      HeroiconsHelper::Cache.clear!

      assert_empty(HeroiconsHelper::Cache::LOOKUP)

      # only the first item is actually new
      items = [@few_data.first] * 5
      HeroiconsHelper::Cache.preload!(items) do |found, icon|
        FakeClass.new(icon) unless found
      end

      assert_equal(1, HeroiconsHelper::Cache::LOOKUP.size)
    end

    def test_does_not_duplicate_cached_items_with_different_attributes
      HeroiconsHelper::Cache.clear!

      assert_empty(HeroiconsHelper::Cache::LOOKUP)

      result = HeroiconsHelper::Cache.get_key(name: :"academic-cap", variant: :solid)

      result_two = HeroiconsHelper::Cache.get_key(name: :"academic-cap", variant: :solid, class: "text-red-500")

      refute_equal(result, result_two)
    end

    def test_cache_evacuates_after_limit_reached
      HeroiconsHelper::Cache.clear!
      HeroiconsHelper::Cache.stub(:limit, 3) do
        # Assert the limit is stubbed properly
        assert_equal(3, HeroiconsHelper::Cache.limit)
        assert_empty(HeroiconsHelper::Cache::LOOKUP)

        # Preload the cache should be 20 items
        HeroiconsHelper::Cache.preload!(@twenty_data) do |found, icon|
          FakeClass.new(icon) unless found
        end

        # Assert the cache size is 3 because the limit is 3
        assert_equal(3, HeroiconsHelper::Cache::LOOKUP.size)
      end
    end
  end
end
