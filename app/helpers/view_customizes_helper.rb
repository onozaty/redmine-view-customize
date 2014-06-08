module ViewCustomizesHelper
  def highlight_by_language(code, language)
    ("<pre><code class=\"#{language} syntaxhl\">" +
         CodeRay.scan(code, language).html(:wrap => :span) +
         "</code></pre>").html_safe
  end
end
