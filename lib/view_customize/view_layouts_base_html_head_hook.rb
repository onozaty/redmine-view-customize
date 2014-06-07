module ViewCustomize
  class ViewLayoutsBaseHtmlHeadHook < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})

#debugger

#      return "<script>alert('"+ "Context keys: #{context.keys.collect(&:to_s).sort.join(', ')}." + "')</script>"
#      return "<script>alert('"+ "#{context[:controller]}." + "')</script>"
#      return "<script>alert('"+ "#{context[:request]}." + "')</script>"
      return context[:request].path_info
    
    end
  end
end
