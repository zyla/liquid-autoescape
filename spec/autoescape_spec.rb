require "liquid/autoescape"

describe "{% autoescape %}" do

  def verify_template_output(template, expected, context={})
    rendered = Liquid::Template.parse(template).render!(context)
    expect(rendered).to eq(expected)
  end

  it "handles empty content" do
    verify_template_output(
      "{% autoescape %}{% endautoescape %}",
      ""
    )
  end

  it "handles non-variable content" do
    verify_template_output(
      "{% autoescape %}Static{% endautoescape %}",
      "Static"
    )
  end

  it "escapes all dangerous HTML characters" do
    verify_template_output(
      "{% autoescape %}{{ variable }}{% endautoescape %}",
      "&lt;tag&gt; &amp; &quot;quote&quot;",
      "variable" => '<tag> & "quote"'
    )
  end

  it "applies HTML escaping to all wrapped variables" do
    verify_template_output(
      "{% autoescape %}{{ one }} {{ two }} {{ three }}{% endautoescape %}",
      "&lt;tag&gt; &amp; &quot;quote&quot;",
      "one" => "<tag>", "two" => "&", "three" => '"quote"'
    )
  end

  it "applies HTML escaping to a filtered variable" do
    verify_template_output(
      "{% autoescape %}{{ filtered | downcase | capitalize }}{% endautoescape %}",
      "A &lt;strong&gt; tag",
      "filtered" => "A <STRONG> Tag"
    )
  end

  it "does not double-escape internal variables" do
    verify_template_output(
      "{% autoescape %}{{ escaped | escape }}{% endautoescape %}",
      "HTML &amp; CSS",
      "escaped" => "HTML & CSS"
    )
  end

  it "does not escape external variables" do
    verify_template_output(
      "{{ variable }}{% autoescape %}{{ variable }}{% endautoescape %}",
      "&&amp;",
      "variable" => "&"
    )
  end

  it "does not escape variables with the skip_escape filter applied" do
    verify_template_output(
      "{% autoescape %}{{ variable | skip_escape }}{% endautoescape %}",
      "<strong>&amp;</strong>",
      "variable" => "<strong>&amp;</strong>"
    )
  end

  it "raises an error when called with arguments" do
    invalid = "{% autoescape on %}{% endautoescape %}"
    expect { Liquid::Template.parse(invalid) }.to raise_error(Liquid::SyntaxError)
  end

end
