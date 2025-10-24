module ViewCustomizesHelper
  def highlight_by_language(code, language)
    code.gsub!(/(\r\n|\r|\n)/, "\n")
    ("<pre><code class=\"#{language} syntaxhl\">" +
         Redmine::SyntaxHighlighting.highlight_by_language(code, language) +
         "</code></pre>").html_safe
  end

  def sprite_icon_or_label(icon_name, label, **options)
    if Gem::Version.new(Redmine::VERSION.to_s) >= Gem::Version.new('6.0.0')
      sprite_icon(icon_name, label, **options)
    else
      label
    end
  end
end
