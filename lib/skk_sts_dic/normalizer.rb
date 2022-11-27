module SkkStsDic
  class Normalizer
    def initialize(items)
      @items = items
    end

    def to_a
      @items = @items.flat_map { |e| e.split(/[:：]/) }
      @items = @items.grep_v(/DEPRECATED/)
      @items = @items.grep_v(/\Aテスト\d+/)
      @items = @items.collect { |e| e.sub(/(スライム)[SML]/, '\1') }
      @items = @items.collect { |e| e.sub(/\(？\)/, "") }
      @items = @items.collect { |e| e.sub(/（？）/, "") }
      @items = @items.collect { |e| e.sub(/\[未使用\]/, "") }
      @items = @items.grep_v(/\Ap{Hiragana}+\z/)
      @items = @items.grep(/\p{Katakana}|\p{Han}/)
      @items = @items.grep_v(/[「」]/)
      @items = @items.collect { |e| e.sub(/！/, "") }
      @items = @items.collect(&:strip)
      @items.uniq!
      @items
    end
  end
end
