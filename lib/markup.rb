module Markup
  extend self

  SANITIZE_CONFIG = Sanitize::Config::RELAXED.deep_dup
  SANITIZE_CONFIG[:attributes]['pre'] = ['class']

  def format(text)
    result = compile_markdown(text)
    result = Sanitize.clean(result, SANITIZE_CONFIG)
    result.html_safe
  end

  private

  def compile_markdown(text)
    placeholders = {}

    text = text.gsub(/\$\$.*?\$\$/m) do |match|
      number = placeholders.size
      placeholders[number] = match
      "{{{#{number}}}}"
    end

    text = RDiscount.new(text).to_html
    text.gsub(%r[{{{(\d+)}}}]) { placeholders[$1.to_i] }
  end
end
