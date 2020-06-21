require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../lib/view_customize/view_hook', __FILE__)

class ViewCustomizeTest < ActiveSupport::TestCase
  #
  #
  class Record
    attr_accessor :path_pattern, :project_pattern, :insertion_position
    def initialize(available, path, project, position)
      @available, @path_pattern, @project_pattern, @insertion_position = available, path, project, position
    end

    def available?
      @available
    end

    def self.store(records)
      @records = records
    end

    def self.get
      @records
    end
  end
  #
  # Replace records
  module ViewCustomizeExt
    refine ViewCustomize do
      class << ViewCustomize 
        def all
          Record.get
        end
      end
    end
  end
  #
  using ViewCustomizeExt
  #
  #
  def test_hook_match_customize
    ctx = {}
    path = "/redmine/issues"
    pos = "html_head"

    Record.store([Record.new(true, ".*", "", "html_head")])

    hook = RedmineViewCustomize::ViewHook.instance
    matches = hook.send(:match_customize, ctx, path, pos)
    assert_equal matches.length, 1

    # right project
    Record.store([Record.new(true, ".*", "testproject", "html_head")])
    matches = hook.send(:match_customize, { "project" => { "identifier" => "testproject" }}, path, pos)
    assert matches.length == 1
    # wrong proejct
    matches = hook.send(:match_customize, { "project" => { "identifier" => "sampleproject" }}, path, pos)
    assert matches.length == 0
    # no project in ctx, but project is in record
    matches = hook.send(:match_customize, {}, path, pos)
    assert matches.length == 0
    # filter by path
    Record.store([Record.new(true, ".*", "", "html_head"), Record.new(true, "/redmine/view_customize", "", "html_head")])
    matches = hook.send(:match_customize, {}, path, pos)
    assert matches.length == 1
    # filter by project and path
    Record.store([Record.new(true, ".*", "", "html_head"), Record.new(true, "/redmine/issues", "testproject", "html_head")])
    matches = hook.send(:match_customize, { "project" => { "identifier" => "testproject" }}, path, pos)
    assert matches.length == 2




  end
end
