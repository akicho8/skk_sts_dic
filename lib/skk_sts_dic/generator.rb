module SkkStsDic
  class Generator
    def generate
      item_collect
      item_normalize
      item_yomigana
      item_output
    end

    private

    def item_collect
      @items = []
      resource_dir.glob("jpn*/*.json") do |e|
        list = JSON.parse(e.read)
        list.each_value do |e|
          v = e["NAME"].to_s.strip
          if v != ""
            @items << v
          end
        end
      end
    end

    def item_normalize
      @items = Normalizer.new(@items).to_a
    end

    def item_yomigana
      @yomi_items = (@items - YomiganaHumeiList.values).collect { |e|
        if yomi = yomi_for(e)
          [yomi, e]
        end
      }.compact.to_h

      @yomi_items.update(YomiganaHumeiList)
    end

    def item_output
      body = @yomi_items.collect { |yomi, item| "#{yomi} /#{item}/\n" }
      str = (Pathname("#{__dir__}/header.txt").readlines + body.sort).join
      output_file.write(str.toeuc)
      puts "write: #{output_file}"
      puts "count: #{body.count}"
    end

    def yomi_for(source)
      HumanReader.new(source).to_s
    end

    def output_file
      Pathname("#{__dir__}/../../SKK-JISYO.sts.dic").expand_path
    end

    def resource_dir
      Pathname("#{__dir__}/translate-the-spire/localization").expand_path
    end
  end
end
