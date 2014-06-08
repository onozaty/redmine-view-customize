module RedmineViewCustomize
  class ViewLayoutsBaseHtmlHeadHook < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})

      view_customize_html_parts = match_customize(context[:request].path_info).map {|item|
        html(item)
      }

      return "<!-- view customize plugin -->\n" + 
        view_customize_html_parts.join("\n").html_safe
    end

    private

    def match_customize(path)

      ViewCustomize.all.select {|item|
        path =~ Regexp.new(item.path_pattern)
      }
    end

    def html(view_customize)

      if view_customize.is_javascript? then
        return "<script type=\"text/javascript\">\n//<![CDATA[\n" + 
          view_customize.code +
          "\n//]]>\n</script>"
      elsif view_customize.is_stylesheet? then
        return "<style type=\"text/css\">\n" +
          view_customize.code +
          "\n</style>"
      end
    end
  end
end
