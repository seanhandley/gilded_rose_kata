class GildedRose

  def initialize(items)
    @items = items
  end

  def update_backstage_pass(item)
    if item.sell_in > 10
      item.quality += 1
    elsif item.sell_in > 5
      item.quality += 2
    elsif item.sell_in > 0
      item.quality += 3
    end
    item.sell_in -= 1
    item
  end

  def update_brie(item)
    item.quality += 1
    item.sell_in -= 1
    item    
  end

  def update_standard_item_or_conjured(item, factor)
    item.sell_in -= 1
    item.quality -= factor   if item.sell_in >= 0
    item.quality -= 2*factor if item.sell_in < 0
    item.quality = 0 if item.quality < 0
    item
  end

  def update_standard_item(item)
    update_standard_item_or_conjured(item, 1)
  end

  def update_conjured(item)
    update_standard_item_or_conjured(item, 2) 
  end

  def update_quality()
    @items.each_with_index do |item, i|
      case item.name
      when "Backstage passes to a TAFKAL80ETC concert"
        @items[i] = update_backstage_pass(item) unless item.quality >= 50
      when "Aged Brie"
        @items[i] = update_brie(item) unless item.quality >= 50
      when "Sulfuras, Hand of Ragnaros"
        # do nothing
      when "Conjured Mana Cake"
        @items[i] = update_conjured(item)
      else
        @items[i] = update_standard_item(item)
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
