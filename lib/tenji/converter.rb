# frozen_string_literal: true

# Tenji provides tools for working with Japanese braille.
# The Converter class offers methods to transform plain text
# into braille representations.

module Tenji
  # Converter is responsible for converting strings(hiragana and katakana) into Japanese braille.
  # Example:
  #   converter = Tenji::Converter
  #   converter.convert_to_tenji("こんにちは")
  #   # => "⠪⠴⠇⠗⠥"
  #
  # If you want to convert Japanese braille (raised dots) into indented dots (mirror form),
  # please use the `convert_to_oumen()` method.
  #   converter.convert_to_oumen("⠪⠴⠇⠗⠥")
  #   # => "⠬⠺⠸⠦⠕"
  class Converter
    def convert_to_tenji(text)
      normalize_text = normalize(text)
      state = :kana
      result = []

      normalize_text.each_char.with_index do |char, i| # rubocop:disable Metrics/BlockLength
        prev_char = i.positive? ? normalize_text[i - 1] : nil
        next_char = i < normalize_text.size - 1 ? normalize_text[i + 1] : nil

        if char == "\n"
          result << char
          next
        end

        case state
        when :kana
          if char.match?(/[0-9]/)
            # 数字がはじまる合図の数符を入れて、number状態に移行
            result << Tenji::Mapping::SUFU
            state = :number
            redo
          elsif char.match?(/[a-zA-Z]/)
            # アルファベットで書かれた文字の前に外字符を入れて、alphabet状態に移行
            result << Tenji::Mapping::GAIJIFU
            state = :alphabet
            redo
          else
            next if convert_kana_to_braille(char, next_char).nil?

            # 数字の後があ行・ら行（りゃ,りゅ,りょ除く）の場合は繋ぎ符を入れる
            if prev_char&.match(/[0-9０-９]/) && %w[ア イ ウ エ オ ラ リ ル レ ロ].include?(char) && !%w[ャ ュ ョ].include?(next_char) # rubocop:disable Style/IfUnlessModifier
              result << Tenji::Mapping::DAI1_TUNAGIFU
            end
            result << convert_kana_to_braille(char, next_char)
          end

        when :number
          if Tenji::Mapping::KANA.include?(char)
            state = :kana
            redo
          end
          if char.match?(/[a-zA-Z]/)
            state = :alphabet
            redo
          end
          result << convert_num_to_braille(char)

        when :alphabet
          if Tenji::Mapping::KANA.include?(char)
            state = :kana
            redo
          end
          if char == /[0-9]/
            state = :number
            redo
          end

          # 大文字の前に大文字符を入れる。その後に続く単語が全て大文字ならば二つ大文字符を入れる
          result << Tenji::Mapping::OOMOJIFU if !prev_char&.match?(/[A-Z]/) && char.match?(/[A-Z]/) && !next_char&.match?(/[A-Z]/)
          result << Tenji::Mapping::OOMOJIFU * 2 if !prev_char&.match?(/[A-Z]/) && char.match?(/[A-Z]/) && next_char&.match?(/[A-Z]/)
          result << convert_alphabet_to_braille(char)
        end
      end
      result.join
    end

    def convert_to_oumen(raised_braille)
      raised_braille.lines.map do |line|
        reversed_line = line.chars.map { |char| braille_mirror(char) }.reverse
        if reversed_line[0] == "\n"
          reversed_line.delete_at(0)
          reversed_line << "\n"
        end
        reversed_line.join
      end.join
    end

    private

    def normalize(text)
      text.each_char.map { |char| to_hankaku(to_kana(char)) }.join
    end

    def to_kana(char)
      char&.tr('ぁ-んゔ', 'ァ-ンヴ')
    end

    def to_hankaku(char)
      char&.tr('０-９．，？！', '0-9.,?!')
    end

    def convert_kana_to_braille(char, next_char)
      return if %w[ャ ュ ョ].include?(char) || %w[ァ ィ ゥ ェ ォ ュ].include?(char)

      is_yoon = %w[キ シ チ ニ ヒ ミ リ ギ ジ ヂ ビ ピ].include?(char) && %w[ャ ュ ョ].include?(next_char)
      is_tokusyuon = %w[ァ ィ ゥ ェ ォ ュ ョ].include?(next_char) && Tenji::Mapping::TOKUSYUON[next_char].include?(char)
      if is_yoon || is_tokusyuon
        one_kana = char << next_char
        Tenji::Mapping::KANA[one_kana]
      else
        Tenji::Mapping::KANA[char]
      end
    end

    def convert_num_to_braille(char)
      Tenji::Mapping::NUNBER[char]
    end

    def convert_alphabet_to_braille(char)
      lowercase = char.downcase
      Tenji::Mapping::ALPHABET[lowercase]
    end

    def braille_mirror(char)
      code_point = char.ord
      return char unless (0x2800..0x283F).cover?(code_point)

      dots = code_point - 0x2800
      mirrored = 0
      mirrored |= 0x08 if dots & 0x01 != 0 # 1→4
      mirrored |= 0x10 if dots & 0x02 != 0 # 2→5
      mirrored |= 0x20 if dots & 0x04 != 0 # 3→6
      mirrored |= 0x01 if dots & 0x08 != 0 # 4→1
      mirrored |= 0x02 if dots & 0x10 != 0 # 5→2
      mirrored |= 0x04 if dots & 0x20 != 0 # 6→3

      (0x2800 + mirrored).chr(Encoding::UTF_8)
    end
  end
end
