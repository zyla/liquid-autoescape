# Liquid Autoescape

This adds an `{% autoescape %}` block tag to Liquid that forces all variables
referenced within it to be escaped for display in an HTML context.

## Usage

To escape all variables, use `{% autoescape %}` to wrap content.

```liquid
{% autoescape %}
  {{ variable_one }}
  {{ variable_two }}
{% endautoescape %}
```

To prevent a variable from being escaped, use the `skip_escape` filter.

```liquid
{% autoescape %}
  {{ untrusted_content }}
  {{ trusted_content | skip_escape }}
{% endautoescape %}
```
