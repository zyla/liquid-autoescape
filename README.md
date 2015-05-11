# Liquid Autoescape

This adds an `{% autoescape %}` block tag to Liquid that causes all variables
referenced within it to be escaped for display in an HTML context.

## Basic Usage

To enable the `{% autoescape %}` tag in your Liquid templates, load the tag's
files in any Ruby file that will be executed before rendering templates using
the following line:

```ruby
require "liquid/autoescape"
```

With the tag loaded, you can escape all variables in a Liquid template by
wrapping them in an `{% autoescape %}` tag.

```liquid
{% autoescape %}
  {{ variable_one }}
  {{ variable_two }}
{% endautoescape %}
```

To prevent a variable contained in an `{% autoescape %}` block from being
escaped, use the `skip_escape` filter.

```liquid
{% autoescape %}
  Escaped: {{ untrusted_content }}
  Not Escaped: {{ trusted_content | skip_escape }}
{% endautoescape %}
```

## Advanced Usage

Autoescaping can be customized to work better with your environment via a
Ruby-level configuration object.  To configure autoescaping, use the `config`
object exposed by `Liquid::Autoescape.configure` in any Ruby file loaded before
templates are rendered.

```ruby
require "liquid/autoescape"

Liquid::Autoescape.configure do |config|
  ...
end
```

The autoescape options that can be configured are detailed below.

### Trusted Filters

If you are using custom Liquid filters that always generate trusted HTML, you
can add them to the list of trusted filters.  Any variables that are passed
through a trusted filter will not be escaped.

```ruby
Liquid::Autoescape.configure do |config|
  config.trusted_filters << :generate_markup
end
```

```liquid
{% autoescape %}
  Escaped: {{ variable | downcase }}
  Not Escaped: {{ variable | generate_markup }}
{% endautoescape %}
```

### Custom Exemptions

If there are complex conditions under which a variable should not be escaped,
you can describe these conditions by creating custom exemptions.  Exemptions are
functions that receive an instance of `Liquid::Autoescape::TemplateVariable`
that represents a Liquid variable as used in a template and return a boolean
value indicating whether the variable is exempt from escaping.

#### Adding Individual Exemptions

To quickly add a single exemption, use code similar to the following:

```ruby
Liquid::Autoescape.configure do |config|
  config.exemptions.add do |variable|
    ...
  end
end
```

#### Importing Exemption Functions

If you prefer to define exemptions as instance methods on a module, you can
import those methods using code similar to the following:

```ruby
module MyExemptions

  def exemption_one(variable)
    ...
  end

  def exemption_two(variable)
    ...
  end

end

Liquid::Autoescape.configure do |config|
  config.exemptions.import(MyExemptions)
end
```

The names of the module methods have no bearing on determining exemptions, so
they can be whatever you want them to be.

#### Exemption Conditions

As mentioned above, each exemption function is passed an object that describes a
Liquid variable as used in a template.  This object exposes the variable's name,
as well as a list of any filters that it uses. These values can be used by each
exemption function to determine whether a variable should be exempt from
autoescaping, as shown by the code below:

```ruby
Liquid::Autoescape.configure do |config|
  config.exemptions.add do |variable|
    variable.name == "var_one" && variable.filters.include?(:downcase)
  end
end
```

```liquid
{% autoescape %}
  Escaped: {{ var_one }}
  Escaped: {{ var_two | downcase }}
  Not Escaped: {{ var_one | downcase }}
{% endautoescape %}
```

### Global Mode

Autoescaping can be globally enabled, which will cause all variables in all
Liquid templates to be escaped, removing the need to use the `{% autoescape %}`
tag.  Trusted filters and custom exemptions still apply in global mode, so there
is always the ability to mark a variable as exempt from escaping.

```ruby
Liquid::Autoescape.configure do |config|
  config.global = true
end
```

```liquid
Escaped: {{ variable }}
Not Escaped: {{ variable | skip_escape }}
```
