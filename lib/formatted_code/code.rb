module FormattedCode
  class Code
    include Comparable

    # For easier specs
    def <=>(other)
      lines.map(&:html) <=> other.lines.map(&:html)
    end

    def initialize(code, language, inline_comments)
      @highlighter = Highlighter.new(code, language)
      @inline_comments = inline_comments
    end

    def lines
      @highlighter.lines.map.with_index do |line, line_number|
        comments_for_line = @inline_comments.fetch(line_number, [])

        CodeLine.new(line.html_safe, line_number, comments_for_line)
      end
    end
  end
end
