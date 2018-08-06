module RedmineViewCustomize
  class ViewHook < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})

      path = context[:request].path_info;

      header = "\n<!-- [view customize plugin] path:#{path} -->\n"
      header << stylesheet_link_tag("view_customize", plugin: "view_customize")

      view_customize_html_parts = match_customize(path, ViewCustomize::INSERTION_POSITION_HTML_HEAD).map {|item|
        html(item)
      }
      header << view_customize_html_parts.join("\n").html_safe
      return header
    end

    def view_issues_form_details_bottom(context={})

      path = context[:request].path_info;

      view_customize_html_parts = match_customize(path, ViewCustomize::INSERTION_POSITION_ISSUE_FORM).map {|item|
        html(item)
      }
      return view_customize_html_parts.join("\n").html_safe
    end

    def view_issues_show_details_bottom(context={})

      path = context[:request].path_info;

      view_customize_html_parts = match_customize(path, ViewCustomize::INSERTION_POSITION_ISSUE_SHOW).map {|item|
        html(item)
      }
      return view_customize_html_parts.join("\n").html_safe
    end

    private

    def match_customize(path, insertion_position)

      ViewCustomize.all.select {|item|
        item.available? \
          && item.insertion_position == insertion_position \
          && path =~ Regexp.new(item.path_pattern)
      }
    end

    def html(view_customize)
      
      html = "<!-- view customize id:#{view_customize.id} -->\n"

      if view_customize.is_javascript? then
        html << "<script type=\"text/javascript\">\n//<![CDATA[\n"
        html << view_customize.code
        html << "\n//]]>\n</script>"
      elsif view_customize.is_stylesheet? then
        html << "<style type=\"text/css\">\n"
        html << view_customize.code
        html << "\n</style>"
      end

      return html
    end
  end
end
