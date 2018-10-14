require_dependency 'view_customize/view_hook'

Redmine::Plugin.register :view_customize do
  requires_redmine :version_or_higher => '3.0.0'
  name 'View Customize plugin'
  author 'onozaty'
  description 'View Customize plugin for Redmine'
  version '2.0.0'
  url 'https://github.com/onozaty/redmine-view-customize'
  author_url 'https://github.com/onozaty'

  menu :admin_menu, :view_customizes,
    { :controller => 'view_customizes', :action => 'index' },
    :caption => :label_view_customize,
    :html => { :class => 'icon icon-view_customize'},
    :if => Proc.new { User.current.admin? }

end
