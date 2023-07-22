Redmine::Plugin.register :view_customize do
  requires_redmine :version_or_higher => '3.1.0'
  name 'View Customize plugin'
  author 'onozaty'
  description 'View Customize plugin for Redmine'
  version '3.4.0'
  url 'https://github.com/onozaty/redmine-view-customize'
  author_url 'https://github.com/onozaty'

  menu :admin_menu, :view_customizes,
    { :controller => 'view_customizes', :action => 'index' },
    :caption => :label_view_customize,
    :html => { :class => 'icon icon-view_customize'},
    :if => Proc.new { User.current.admin? }

  settings :default => { 'create_api_access_key' => '' }, :partial => 'settings/view_customize_settings'

  should_be_disabled false if Redmine::Plugin.installed?(:easy_extensions)
end

unless Redmine::Plugin.installed?(:easy_extensions)
  require_relative 'after_init'
end
