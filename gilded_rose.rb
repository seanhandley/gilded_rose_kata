class GildedRose

  def initialize(items)
    @items = items
  end

  def strategies
    @items.map do |item|
      case item.name
      when "Backstage passes to a TAFKAL80ETC concert"
        BackStageStrategy.new(item)
      when "Aged Brie"
        BrieStrategy.new(item)
      when "Sulfuras, Hand of Ragnaros"
        SulfurasStrategy.new(item)
      when "Conjured Mana Cake"
        ConjuredItemStrategy.new(item)
      else
        ItemStrategy.new(item)
      end
    end
  end

  def update_quality
    strategies.each(&:update_quality)
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name    = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class ItemStrategy
  def initialize(item)
    @item = item
  end

  def update_quality
    @item.sell_in -= 1
    @item.quality -= 1   if @item.sell_in >= 0
    @item.quality -= 2   if @item.sell_in < 0
    @item.quality = 0    if @item.quality < 0
    @item
  end
end

class ConjuredItemStrategy < ItemStrategy
  def update_quality
    @item.sell_in -= 1
    @item.quality -= 2   if @item.sell_in >= 0
    @item.quality -= 4   if @item.sell_in < 0
    @item.quality = 0    if @item.quality < 0
    @item
  end
end

class BrieStrategy < ItemStrategy
  def update_quality
    return @item if @item.quality >= 50
    @item.quality += 1
    @item.sell_in -= 1
    @item
  end
end

class SulfurasStrategy < ItemStrategy
  def update_quality ; end
end

class BackStageStrategy < ItemStrategy
  def update_quality
    return @item if @item.quality >= 50
    if @item.sell_in > 10
      @item.quality += 1
    elsif @item.sell_in > 5
      @item.quality += 2
    elsif @item.sell_in > 0
      @item.quality += 3
    end
    @item.sell_in -= 1
    @item
  end
end
