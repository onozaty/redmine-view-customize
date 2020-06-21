require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../lib/view_customize/view_hook', __FILE__)

class ViewCustomizeTest < ActiveSupport::TestCase
  fixtures :projects
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
  class Request
    attr_accessor :path
    def initialize(path)
      @path = path
    end

    def path_info
      @path
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
    request = Request.new("/redmine/issues")
    pos = "html_head"
    project1 = Project.find(1)
    project2 = Project.find(2)

    Record.store([Record.new(true, ".*", "", "html_head")])

    hook = RedmineViewCustomize::ViewHook.instance
    matches = hook.send(:match_customize, {:request => request}, pos)
    assert_equal matches.length, 1

    # right project
    Record.store([Record.new(true, ".*", project1.identifier, "html_head")])
    matches = hook.send(:match_customize, {:request => request, :project => project1}, pos)
    assert matches.length == 1
    # wrong proejct
    matches = hook.send(:match_customize, {:request => request, :project => project2}, pos)
    assert matches.length == 0
    # no project, but project is in record
    matches = hook.send(:match_customize, {:request => request}, pos)
    assert matches.length == 0
    # filter by path
    Record.store([Record.new(true, ".*", "", "html_head"), Record.new(true, "/redmine/view_customize", "", "html_head")])
    matches = hook.send(:match_customize, {:request => request}, pos)
    assert matches.length == 1
    # filter by project and path
    Record.store([Record.new(true, ".*", "", "html_head"), Record.new(true, "/redmine/issues", project1.identifier, "html_head")])
    matches = hook.send(:match_customize, {:request => request, :project => project1}, pos)
    assert matches.length == 2

  end
end
