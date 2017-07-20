require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'test/unit'

class TestUntitled < Test::Unit::TestCase

  def setup
    @items = [
      Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20),
      Item.new(name="Aged Brie", sell_in=100, quality=0),
      Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7),
      Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80),
      Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=39),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=39),
      # This Conjured item does not work properly yet
      Item.new(name="Conjured Mana Cake", sell_in=3, quality=6), # <-- :O
    ]
  end

  def test_that_quality_degrades_at_a_normal_rate_before_sell_by_date
    GildedRose.new(@items).update_quality()
    assert_equal 19, @items[0].quality
  end

  def test_that_quality_degrades_at_twice_the_normal_rate_after_sell_by_date
    10.times { GildedRose.new(@items).update_quality() }
    assert_equal 10, @items[0].quality
    GildedRose.new(@items).update_quality()
    assert_equal 8, @items[0].quality
  end

  def test_item_quality_is_never_negative
    1000.times { GildedRose.new(@items).update_quality() }
    @items.each do |item|
      assert_operator 0, :<=, item.quality
    end
  end

  def test_item_quality_does_not_exceed_50
    assert_equal 0, @items[1].quality
    49.times { GildedRose.new(@items).update_quality() }
    assert_equal 49, @items[1].quality
    2.times { GildedRose.new(@items).update_quality() }
    assert_equal 50, @items[1].quality
  end

  def test_aged_brie_increases_in_quality_over_time
    assert_equal 0, @items[1].quality
    GildedRose.new(@items).update_quality()
    assert_operator 0, :<, @items[1].quality
  end

  def test_sulfuras_never_changes_quality_or_sell_in
    test_sulfuras = -> {
      assert_equal 0, @items[3].sell_in
      assert_equal 80, @items[3].quality
    }
    test_sulfuras.call
    10.times { GildedRose.new(@items).update_quality() }
    test_sulfuras.call
  end

  def test_backstage_passes_increses_quality_by_one_day
    assert_equal 20, @items[5].quality
    GildedRose.new(@items).update_quality()
    assert_equal 21, @items[5].quality
  end

  def test_backstage_passes_increses_quality_by_two
    assert_equal 39, @items[6].quality
    GildedRose.new(@items).update_quality()
    assert_equal 41, @items[6].quality
  end

  def test_backstage_passes_increses_quality_by_three
    assert_equal 39, @items[7].quality
    GildedRose.new(@items).update_quality()
    assert_equal 42, @items[7].quality
  end

  def test_conjured_items_deterioriate_twice_as_fast
    3.times { GildedRose.new(@items).update_quality() }
    assert_equal 0, @items[8].quality
  end

end