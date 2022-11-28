module SkkStsDic
  class Generator
    def generate
      items_collect
      items_normalize
      items_yomigana
      items_output
    end

    private

    def items_collect
      @items = []
      localization_dir.glob("jpn*/*.json") do |e|
        list = JSON.parse(e.read)
        list.each_value do |e|
          [e["NAME"], e["NAMES"]].flatten.compact.each do |e|
            v = e.to_s.strip
            if v != ""
              @items << v
            end
          end
        end
      end
    end

    def items_normalize
      @items = Normalizer.new(@items).to_a
    end

    def items_yomigana
      ary = @items - MysteryWord.values
      @yomi_items = ary.collect { |e|
        yomi = yomi_for(e)
        if yomi != ""
          [yomi, e]
        end
      }.compact.to_h
      @yomi_items.update(MysteryWord)
    end

    def items_output
      body = @yomi_items.collect { |yomi, item| "#{yomi} /#{item}/\n" }.sort
      puts "count: #{body.count}"

      [
        [".euc-jp", :toeuc],
        [".utf-8",  :toutf8],
      ].each do |coding_ext, method|
        file = output_file(coding_ext)
        file.write((header + body).join.send(method))
        puts "write: #{file}"
      end
    end

    def yomi_for(source)
      HumanReader.new(source).to_s
    end

    def output_file(coding_ext)
      Pathname("#{__dir__}/../../SKK-JISYO.sts#{coding_ext}.dic").expand_path
    end

    def localization_dir
      Pathname("#{__dir__}/translate-the-spire/localization").expand_path
    end

    def header
      Pathname("#{__dir__}/header.txt").readlines
    end
  end
end
