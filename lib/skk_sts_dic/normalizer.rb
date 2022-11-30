module SkkStsDic
  class Normalizer
    def initialize(items)
      @items = items
    end

    def to_a
      # 分割
      @items = @items.flat_map { |e| e.split(/[:：]/) }

      # 置換
      @items = @items.collect(&method(:replace))

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

    private

    def replace(s)
      s = s.gsub(/(スライム)[SML]/, '\1')
      s = s.gsub(/(登塔クラス|アセンド)\s*\d+/, '\1')
      s = s.gsub(/~(.+)~/, '\1')
      s = s.gsub(/\(？\)/, "")
      s = s.gsub(/（？）/, "")
      s = s.gsub(/\[未使用\]/, "")
      s = s.gsub(/\+\z/, "")
      s = s.gsub(/！/, "")
      s = s.gsub(/\p{Blank}+/, " ")
    end
  end
end
