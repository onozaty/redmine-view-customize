module ViewCustomizesHelper
  def highlight_by_language(code, language)
    ("<pre><code class=\"#{language} syntaxhl\">" +
         Redmine::SyntaxHighlighting.highlight_by_language(code, language) +
         "</code></pre>").html_safe
  end
end
