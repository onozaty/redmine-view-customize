require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../lib/view_customize/view_hook', __FILE__)

class ViewCustomizeViewHookTest < ActiveSupport::TestCase
  fixtures :view_customizes, :projects, :users

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
end
