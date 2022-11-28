module SkkStsDic
  class Normalizer
    def initialize(items)
      @items = items
    end

    def to_a
      # 分割
      @items = @items.flat_map { |e| e.split(/[:：]/) }

      # 置換
      @items = @items.collect { |e| e.gsub(/(スライム)[SML]/, '\1') }
      @items = @items.collect { |e| e.gsub(/(登塔クラス|アセンド)\s*\d+/, '\1') }
      @items = @items.collect { |e| e.gsub(/~(.+)~/, '\1') }
      @items = @items.collect { |e| e.gsub(/\(？\)/, "") }
      @items = @items.collect { |e| e.gsub(/（？）/, "") }
      @items = @items.collect { |e| e.gsub(/\[未使用\]/, "") }
      @items = @items.collect { |e| e.gsub(/\+\z/, "") }
      @items = @items.collect { |e| e.gsub(/！/, "") }
      @items = @items.collect { |e| e.gsub(/\p{Blank}+/, " ") }

      # 除外
      @items = @items.grep_v(/DEPRECATED/)
      @items = @items.grep_v(/[「」]/)
      @items = @items.grep_v(/\Aテスト\d+/)
      @items = @items.grep_v(/[#@]/)
      @items = @items.grep_v(/。\z/)
      @items = @items.grep_v(/削除するカードを.*枚手札から選択する/)
      @items = @items.grep_v(/\Ap{Hiragana}+\z/)

      # 必要
      @items = @items.grep(/\p{Katakana}|\p{Han}/)

      @items = @items.collect(&:strip)
      @items.uniq!
      @items
    end
  end
end
