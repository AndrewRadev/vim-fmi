require 'rails_helper'

describe Markup do
  def format(input)
    Markup.format(input).strip
  end

  it "makes *this_string* emphasized" do
    expect(format('*this_string*')).to include('<p><em>this_string</em></p>')
  end

  it "converts `backticked strings` to code blocks" do
    expect(format('`foo()`')).to include('<code>foo()</code>')
  end

  it "removes adds nofollow to hyperlinks" do
    input = '<a href="#" onclick="maliciousCode()">link</a>'
    output = '<a href="#">link</a>'

    expect(format(input)).to include(output)
  end

  it "removes script tags" do
    input = '<script type="text/javascript">maliciousCode()</script>'

    expect(format(input)).not_to include('<script')
  end

  it "generates an html safe string" do
    expect(Markup.format('')).to be_html_safe
  end

  it "preserves embedded LaTeX" do
    expect(Markup.format("$$ _foo_ \n _bar_ $$")).to eq "<p>$$ _foo_ \n _bar_ $$</p>\n"
  end

  it "allows setting class on <pre>" do
    expect(format('<pre class="baba"></pre>')).to include('<pre class="baba"></pre>')
  end
end
