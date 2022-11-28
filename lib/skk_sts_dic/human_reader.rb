module SkkStsDic
  class HumanReader
    def initialize(text)
      @text = text
    end

    def to_s
      str = normalize
      if str.match?(/\A[\p{Hiragana}]+\z/)
        return str
      end
      if str.match?(/\A[\p{Katakana}ー]+\z/)
        return hiragana_from(str)
      end
      begin
        nm = Natto::MeCab.new("-F%f[7]")
        list = nm.enum_parse(str)
        list = list.take_while { |e| !e.is_eos? }
        str = list.collect(&:feature).join
        hiragana_from(str)
      rescue Natto::MeCabError => error
        warn "skip: #{@text}"
        ""
      end
    end

    private

    def normalize
      str = @text
      str = str.gsub(/[・！]/, "")
      str = str.gsub(/ヴィ/, "ビ")
      str = str.gsub(/ヴー/, "ブー")
      str = str.gsub(/ヴォ/, "ボ")
      str = str.gsub(/\s+/, "")
    end

    def hiragana_from(text)
      NKF.nkf("-w --hiragana", text)
    end
  end
end
