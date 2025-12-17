# frozen_string_literal: true

RSpec.describe Tenji do
  it 'has a version number' do
    expect(Tenji::VERSION).not_to be nil
  end

  # WARNING: 点字のスペースはスペースのコードではなく、点字の無点（U+2800)
  describe '#convert_to_tenji' do
    converter = Tenji::Converter.new
    it 'converts text containing 清音' do
      # 清音
      seion = 'あいうえお　かきくけこ　さしすせそ　たちつてと　なにぬねの　はひふへほ　まみむめも　やゆよ　らりるれろ　わをん'
      seion_kana = 'アイウエオ カキクケコ　サシスセソ　タチツテト　ナニヌネノ　ハヒフヘホ　マミムメモ　ヤユヨ　ラリルレロ　ワヲン'
      expect(converter.convert_to_tenji(seion)).to eq('⠁⠃⠉⠋⠊⠀⠡⠣⠩⠫⠪⠀⠱⠳⠹⠻⠺⠀⠕⠗⠝⠟⠞⠀⠅⠇⠍⠏⠎⠀⠥⠧⠭⠯⠮⠀⠵⠷⠽⠿⠾⠀⠌⠬⠜⠀⠑⠓⠙⠛⠚⠀⠄⠔⠴')
      expect(converter.convert_to_tenji(seion_kana)).to eq('⠁⠃⠉⠋⠊⠀⠡⠣⠩⠫⠪⠀⠱⠳⠹⠻⠺⠀⠕⠗⠝⠟⠞⠀⠅⠇⠍⠏⠎⠀⠥⠧⠭⠯⠮⠀⠵⠷⠽⠿⠾⠀⠌⠬⠜⠀⠑⠓⠙⠛⠚⠀⠄⠔⠴')
    end

    it 'converts text containing 濁音、半濁音' do
      # 濁音、半濁音
      dakuon = 'がぎぐげご　ざじずぜぞ　だぢづでど　ばびぶべぼ　ぱぴぷぺぽ'
      dakuon_kana = 'ガギグゲゴ　ザジズゼゾ　ダヂヅデド　バビブベボ　パピプペポ'
      expect(converter.convert_to_tenji(dakuon)).to eq('⠐⠡⠐⠣⠐⠩⠐⠫⠐⠪⠀⠐⠱⠐⠳⠐⠹⠐⠻⠐⠺⠀⠐⠕⠐⠗⠐⠝⠐⠟⠐⠞⠀⠐⠥⠐⠧⠐⠭⠐⠯⠐⠮⠀⠠⠥⠠⠧⠠⠭⠠⠯⠠⠮')
      expect(converter.convert_to_tenji(dakuon_kana)).to eq('⠐⠡⠐⠣⠐⠩⠐⠫⠐⠪⠀⠐⠱⠐⠳⠐⠹⠐⠻⠐⠺⠀⠐⠕⠐⠗⠐⠝⠐⠟⠐⠞⠀⠐⠥⠐⠧⠐⠭⠐⠯⠐⠮⠀⠠⠥⠠⠧⠠⠭⠠⠯⠠⠮')
    end

    it 'converts text containing 拗音、拗濁音、拗半濁音' do
      # 拗音、拗濁音、拗半濁音
      yoon = 'きゃきゅきょ　しゃしゅしょ　ちゃちゅちょ　にゃにゅにょ　ひゃひゅひょ　みゃみゅみょ　りゃりゅりょ　ぎゃぎゅぎょ　じゃじゅじょ　ぢゃぢゅぢょ　びゃびゅびょ　ぴゃぴゅぴょ'
      yoon_kana = 'キャキュキョ　シャシュショ　チャチュチョ　ニャニュニョ　ヒャヒュヒョ　ミャミュミョ　リャリュリョ　ギャギュギョ　ジャジュジョ　ヂャヂュヂョ　ビャビュビョ　ピャピュピョ'
      expect(converter.convert_to_tenji(yoon)).to eq('⠈⠡⠈⠩⠈⠪⠀⠈⠱⠈⠹⠈⠺⠀⠈⠕⠈⠝⠈⠞⠀⠈⠅⠈⠍⠈⠎⠀⠈⠥⠈⠭⠈⠮⠀⠈⠵⠈⠽⠈⠾⠀⠈⠑⠈⠙⠈⠚⠀⠘⠡⠘⠩⠘⠪⠀⠘⠱⠘⠹⠘⠺⠀⠘⠕⠘⠝⠘⠞⠀⠘⠥⠘⠭⠘⠮⠀⠨⠥⠨⠭⠨⠮')
      expect(converter.convert_to_tenji(yoon_kana)).to eq('⠈⠡⠈⠩⠈⠪⠀⠈⠱⠈⠹⠈⠺⠀⠈⠕⠈⠝⠈⠞⠀⠈⠅⠈⠍⠈⠎⠀⠈⠥⠈⠭⠈⠮⠀⠈⠵⠈⠽⠈⠾⠀⠈⠑⠈⠙⠈⠚⠀⠘⠡⠘⠩⠘⠪⠀⠘⠱⠘⠹⠘⠺⠀⠘⠕⠘⠝⠘⠞⠀⠘⠥⠘⠭⠘⠮⠀⠨⠥⠨⠭⠨⠮')
    end

    it 'converts text containing 特殊音' do
      # 特殊音
      tokusyu = 'いぇきぇしぇじぇちぇにぇひぇ　うぃうぇうぉ　くぁくぃくぇくぉ　ぐぁぐぃぐぇぐぉ　つぁつぃつぇつぉ　ふぁふぃふぇふぉ　ゔぁゔぃゔぇゔぉ　すぃずぃてぃでぃとぅどぅてゅでゅふゅゔゅふょゔょゔ'
      tokusyu_kana = 'イェキェシェジェチェニェヒェ　ウィウェウォ　クァクィクェクォ　グァグィグェグォ　ツァツィツェツォ　ファフィフェフォ　ヴァヴィヴェヴォ　スィズィティディトゥドゥテュデュフュヴュフョヴョヴ'
      expect(converter.convert_to_tenji(tokusyu)).to eq('⠈⠋⠈⠫⠈⠻⠘⠻⠈⠟⠈⠏⠈⠯⠀⠢⠃⠢⠋⠢⠊⠀⠢⠡⠢⠣⠢⠫⠢⠪⠀⠲⠡⠲⠣⠲⠫⠲⠪⠀⠢⠕⠢⠗⠢⠟⠢⠞⠀⠢⠥⠢⠧⠢⠯⠢⠮⠀⠲⠥⠲⠧⠲⠯⠲⠮⠀⠈⠳⠘⠳⠈⠗⠘⠗⠢⠝⠲⠝⠨⠝⠸⠝⠨⠬⠸⠬⠨⠜⠸⠜⠐⠉')
      expect(converter.convert_to_tenji(tokusyu_kana)).to eq('⠈⠋⠈⠫⠈⠻⠘⠻⠈⠟⠈⠏⠈⠯⠀⠢⠃⠢⠋⠢⠊⠀⠢⠡⠢⠣⠢⠫⠢⠪⠀⠲⠡⠲⠣⠲⠫⠲⠪⠀⠢⠕⠢⠗⠢⠟⠢⠞⠀⠢⠥⠢⠧⠢⠯⠢⠮⠀⠲⠥⠲⠧⠲⠯⠲⠮⠀⠈⠳⠘⠳⠈⠗⠘⠗⠢⠝⠲⠝⠨⠝⠸⠝⠨⠬⠸⠬⠨⠜⠸⠜⠐⠉')
    end

    it 'converts text containing 促音、長音符' do
      # 促音、長音符
      text = 'あっち　そっち　どっち　おかあさん　おとーさんと　うんどーかいへ　いった'
      expect(converter.convert_to_tenji(text)).to eq('⠁⠂⠗⠀⠺⠂⠗⠀⠐⠞⠂⠗⠀⠊⠡⠁⠱⠴⠀⠊⠞⠒⠱⠴⠞⠀⠉⠴⠐⠞⠒⠡⠃⠯⠀⠃⠂⠕')
    end

    context 'when text containing the number' do
      it 'converts all numbers and symbols' do
        text = '1234567890 3.14 1,234,567'
        expect(converter.convert_to_tenji(text)).to eq('⠼⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠀⠼⠉⠂⠁⠙⠀⠼⠁⠄⠃⠉⠙⠄⠑⠋⠛')
      end

      it 'converts numbers even when mixed with hiragana' do
        text = '1ちょー　２４００まん　３ぶんの１'
        expect(converter.convert_to_tenji(text)).to eq('⠼⠁⠈⠞⠒⠀⠼⠃⠙⠚⠚⠵⠴⠀⠼⠉⠐⠭⠴⠎⠼⠁')
      end

      it 'adds 数符 when the following character belongs to the あ row or the ら row' do
        text = '1えん　２り　３うぉん　４い　５りょう'
        expect(converter.convert_to_tenji(text)).to eq('⠼⠁⠤⠋⠴⠀⠼⠃⠤⠓⠀⠼⠉⠢⠊⠴⠀⠼⠙⠤⠃⠀⠼⠑⠈⠚⠉')
      end
    end

    context 'when text containing the alphabet' do
      it 'adds 外字符 when text containing the alphabet' do
        text = 'abcdefg hijklmn opqrstu vwxyz'
        expect(converter.convert_to_tenji(text)).to eq('⠰⠁⠃⠉⠙⠑⠋⠛⠀⠰⠓⠊⠚⠅⠇⠍⠝⠀⠰⠕⠏⠟⠗⠎⠞⠥⠀⠰⠧⠺⠭⠽⠵')
      end

      it 'adds 大文字符 before uppercase alphabet characters' do
        text = 'No 1だね A B C'
        expect(converter.convert_to_tenji(text)).to eq('⠰⠠⠝⠕⠀⠼⠁⠐⠕⠏⠀⠰⠠⠁⠀⠰⠠⠃⠀⠰⠠⠉')
      end

      it 'adds two 大文字符 if uppercase alphabet characters occur consecutively.' do
        text = 'OPEC CD PC PTA TV VIP SF PDF'
        expect(converter.convert_to_tenji(text)).to eq('⠰⠠⠠⠕⠏⠑⠉⠀⠰⠠⠠⠉⠙⠀⠰⠠⠠⠏⠉⠀⠰⠠⠠⠏⠞⠁⠀⠰⠠⠠⠞⠧⠀⠰⠠⠠⠧⠊⠏⠀⠰⠠⠠⠎⠋⠀⠰⠠⠠⠏⠙⠋')
      end
    end

    context 'when text containing a mix of kanji, numbers, alphabets, and hiragana' do
      it 'converts numbers, alphabets, and hiragana, and removes all other characters' do
        text = 'その　人と　２ねんも　あってない。　けつえきがたわ　A B O AB　のどれ？　わ　びっくりした！'
        expect(converter.convert_to_tenji(text)).to eq('⠺⠎⠀⠞⠀⠼⠃⠏⠴⠾⠀⠁⠂⠟⠅⠃⠲⠀⠫⠝⠋⠣⠐⠡⠕⠄⠀⠰⠠⠁⠀⠰⠠⠃⠀⠰⠠⠕⠀⠰⠠⠠⠁⠃⠀⠎⠐⠞⠛⠢⠀⠄⠀⠐⠧⠂⠩⠓⠳⠕⠖')
      end

      it 'handles contiguous letters and hiragana without interrupting conversion' do
        text = 'a5　abcそんぐ　1p　2にん　まる1　さいずA'
        expect(converter.convert_to_tenji(text)).to eq('⠰⠁⠼⠑⠀⠰⠁⠃⠉⠺⠴⠐⠩⠀⠼⠁⠰⠏⠀⠼⠃⠇⠴⠀⠵⠙⠼⠁⠀⠱⠃⠐⠹⠰⠠⠁')
      end
    end
  end

  describe '#convert_to_indented_braille' do
    converter = Tenji::Converter.new
    it 'mirrors braille horizontally for the entire text' do
      text = '⠀⠁⠂⠃⠄⠅⠆⠇⠉⠊⠋⠌⠍⠎⠏⠒⠓⠔⠕⠖⠗⠛⠜⠝⠞⠟⠤⠥⠦⠧⠭⠮⠯⠶⠷⠿'
      expect(converter.convert_to_oumen(text)).to eq('⠿⠾⠶⠽⠵⠭⠼⠴⠬⠤⠻⠳⠫⠣⠛⠺⠲⠪⠢⠚⠒⠹⠱⠩⠡⠙⠑⠉⠸⠰⠨⠠⠘⠐⠈⠀')
    end

    it 'reverses braille correctly with line breaks preserved' do
      text = "⠁⠃⠉⠋⠊\n⠡⠣⠩⠫⠪\n⠱⠳⠹⠻⠺"
      expect(converter.convert_to_oumen(text)).to eq("⠑⠙⠉⠘⠈\n⠕⠝⠍⠜⠌\n⠗⠟⠏⠞⠎")
    end
  end
end
