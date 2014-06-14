require_dependency 'view_customize/view_layouts_base_html_head_hook'

Redmine::Plugin.register :view_customize do
  name 'View Customize plugin'
  author 'onozaty'
  description 'View Customize plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/onozaty/redmine-view-customize'
  author_url 'https://github.com/onozaty'

  menu :admin_menu, :view_customizes,
    { :controller => 'view_customizes', :action => 'index' },
    :caption => :label_view_customize,
    :if => Proc.new { User.current.admin? }

end
