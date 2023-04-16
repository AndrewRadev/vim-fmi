module FormattedCode
  class Diff
    def initialize(from, to, language, inline_comments)
      @diff = Differ.new(from, to).changes
      @highlighter = Highlighter.new(to, language)

      @inline_comments = inline_comments
    end

    def stats
      added = 0
      removed = 0

      @diff.flat_map do |change|
        case change.action
        when '+' then added += 1
        when '-' then removed += 1
        end
      end

      [added, removed]
    end

    def lines
      @diff.flat_map do |change|
        comments_for_line = @inline_comments.fetch(change.new_position, [])
        new_highlighted_line = @highlighter.lines[change.new_position]

        case change.action
        when '-'
          [DiffLine.new('-', ERB::Util.html_escape(change.old_element), nil, [])]
        when '+'
          [DiffLine.new('+', new_highlighted_line, change.new_position, comments_for_line)]
        else
          [DiffLine.new('=', new_highlighted_line, change.new_position, comments_for_line)]
        end
      end
    end
  end
end
