require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../lib/redmine_view_customize/view_hook', __FILE__)

class ViewCustomizeViewHookTest < ActiveSupport::TestCase
  fixtures :projects, :users, :email_addresses, :user_preferences, :members, :member_roles, :roles,
           :issues, :journals, :custom_fields, :custom_fields_projects, :custom_values,
           :view_customizes

  class Request
    def initialize(path)
      @path = path
    end

    def path_info
      @path
    end
  end

  def setup
    @project_ecookbook = Project.find(1)
    @project_onlinestore = Project.find(2)
    @hook = RedmineViewCustomize::ViewHook.instance
  end

  def test_match_customize

    User.current = User.find(1)

    matches = @hook.send(:match_customize, {:request => Request.new("/")}, ViewCustomize::INSERTION_POSITION_HTML_HEAD)
    assert_equal [2], matches.map {|x| x.id }

    # path pattern
    matches = @hook.send(:match_customize, {:request => Request.new("/issues")}, ViewCustomize::INSERTION_POSITION_HTML_HEAD)
    assert_equal [1, 2], matches.map {|x| x.id }

    matches = @hook.send(:match_customize, {:request => Request.new("/issues/1")}, ViewCustomize::INSERTION_POSITION_HTML_HEAD)
    assert_equal [2], matches.map {|x| x.id }

    # project pattern
    matches = @hook.send(:match_customize, {:request => Request.new("/issues"), :project => @project_ecookbook}, ViewCustomize::INSERTION_POSITION_HTML_HEAD)
    assert_equal [1, 2, 3], matches.map {|x| x.id }

    matches = @hook.send(:match_customize, {:request => Request.new("/issues"), :project => @project_onlinestore}, ViewCustomize::INSERTION_POSITION_HTML_HEAD)
    assert_equal [1, 2], matches.map {|x| x.id }

    # path and project pattern
    matches = @hook.send(:match_customize, {:request => Request.new("/issues/new"), :project => @project_ecookbook}, ViewCustomize::INSERTION_POSITION_HTML_HEAD)
    assert_equal [2, 3, 4], matches.map {|x| x.id }

    # private
    User.current = User.find(2)
    matches = @hook.send(:match_customize, {:request => Request.new("/")}, ViewCustomize::INSERTION_POSITION_HTML_HEAD)
    assert_equal [2, 6], matches.map {|x| x.id }

    # insertion position
    matches = @hook.send(:match_customize, {:request => Request.new("/issues")}, ViewCustomize::INSERTION_POSITION_ISSUE_FORM)
    assert_empty matches

    matches = @hook.send(:match_customize, {:request => Request.new("/issues/new"), :project => @project_ecookbook}, ViewCustomize::INSERTION_POSITION_ISSUE_FORM)
    assert_equal [7], matches.map {|x| x.id }
    matches = @hook.send(:match_customize, {:request => Request.new("/issues/new"), :project => @project_onlinestore}, ViewCustomize::INSERTION_POSITION_ISSUE_FORM)
    assert_equal [7], matches.map {|x| x.id }

    matches = @hook.send(:match_customize, {:request => Request.new("/issues/123"), :project => @project_onlinestore}, ViewCustomize::INSERTION_POSITION_ISSUE_SHOW)
    assert_equal [8], matches.map {|x| x.id }

  end

  def test_view_layouts_base_html_head

    User.current = User.find(1)

    expected = Regexp.escape("\n")
    expected << Regexp.escape("<!-- [view customize plugin] path:/issues -->\n")
    expected << Regexp.escape("<link rel=\"stylesheet\" media=\"screen\" href=\"/plugin_assets/view_customize/stylesheets/view_customize.css?")
    expected << "[0-9]+"
    expected << Regexp.escape("\" /><script type=\"text/javascript\">\n")
    expected << Regexp.escape("//<![CDATA[\n")
    expected << Regexp.escape("ViewCustomize = { context: {\"user\":{\"id\":1,\"login\":\"admin\",\"admin\":true,\"firstname\":\"Redmine\",\"lastname\":\"Admin\",\"mail\":\"admin@somenet.foo\",\"lastLoginOn\":\"2006-07-19T20:57:52Z\",\"groups\":[],\"apiKey\":null,\"customFields\":[{\"id\":4,\"name\":\"Phone number\",\"value\":null},{\"id\":5,\"name\":\"Money\",\"value\":null}]},\"project\":{\"id\":1,\"identifier\":\"ecookbook\",\"name\":\"eCookbook\",\"roles\":[{\"id\":4,\"name\":\"Non member\"}],\"customFields\":[{\"id\":3,\"name\":\"Development status\",\"value\":\"Stable\"}]}} };\n")
    expected << Regexp.escape("//]]>\n")
    expected << Regexp.escape("</script>\n")
    expected << Regexp.escape("<!-- view customize id:1 -->\n")
    expected << Regexp.escape("<script type=\"text/javascript\">\n")
    expected << Regexp.escape("//<![CDATA[\n")
    expected << Regexp.escape("code_001\n")
    expected << Regexp.escape("//]]>\n")
    expected << Regexp.escape("</script>\n")
    expected << Regexp.escape("<!-- view customize id:2 -->\n")
    expected << Regexp.escape("<style type=\"text/css\">\n")
    expected << Regexp.escape("code_002\n")
    expected << Regexp.escape("</style>\n")
    expected << Regexp.escape("<!-- view customize id:3 -->\n")
    expected << Regexp.escape("code_003\n")

    html = @hook.view_layouts_base_html_head({:request => Request.new("/issues"), :project => @project_ecookbook})
    assert_match Regexp.new(expected), html

  end

  def test_view_layouts_base_body_bottom

    User.current = User.find(1)

    expected = <<HTML

<!-- view customize id:9 -->
<script type=\"text/javascript\">
//<![CDATA[
code_009
//]]>
</script>
HTML

    html = @hook.view_layouts_base_body_bottom({:request => Request.new("/issues"), :project => @project_ecookbook})
    assert_equal expected, html
  end

  def test_view_issues_context_menu_end

    User.current = User.find(1)

    expected = <<HTML

<!-- view customize id:10 -->
<script type=\"text/javascript\">
//<![CDATA[
code_010
//]]>
</script>
HTML

    html = @hook.view_issues_context_menu_end({:request => Request.new("/issues")})
    assert_equal expected, html
  end

  def test_view_issues_form_details_bottom

    User.current = User.find(1)

    expected = <<HTML

<!-- view customize id:7 -->
code_007
HTML

    html = @hook.view_issues_form_details_bottom({:request => Request.new("/issues/new"), :project => @project_ecookbook})
    assert_equal expected, html

  end

  def test_view_issues_show_details_bottom

    User.current = User.find(1)
    issue = Issue.find(4)

    expected = <<HTML

<script type=\"text/javascript\">
//<![CDATA[
ViewCustomize.context.issue = {\"id\":4,\"author\":{\"id\":2,\"name\":\"John Smith\"}};
//]]>
</script>
<!-- view customize id:8 -->
<style type=\"text/css\">
code_008
</style>
HTML

    html = @hook.view_issues_show_details_bottom({:request => Request.new("/issues/4"), :issue => issue, :project => @project_onlinestore})
    assert_equal expected, html

  end

  def test_view_issues_show_details_bottom_with_journals

    User.current = User.find(1)
    issue = Issue.find(6)

    expected = <<HTML

<script type=\"text/javascript\">
//<![CDATA[
ViewCustomize.context.issue = {\"id\":6,\"author\":{\"id\":2,\"name\":\"John Smith\"},\"lastUpdatedBy\":{\"id\":1,\"name\":\"Redmine Admin\"}};
//]]>
</script>
<!-- view customize id:8 -->
<style type=\"text/css\">
code_008
</style>
HTML

    html = @hook.view_issues_show_details_bottom({:request => Request.new("/issues/6"), :issue => issue, :project => @project_onlinestore})
    assert_equal expected, html

  end

end
