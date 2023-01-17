class ViewCustomize < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  validates_length_of :path_pattern, :maximum => 255
  validates_length_of :project_pattern, :maximum => 255

  validates_presence_of :code

  validate :valid_pattern

  TYPE_JAVASCRIPT = "javascript"
  TYPE_CSS = "css"
  TYPE_HTML = "html"

  @@customize_types = {
    :label_javascript => TYPE_JAVASCRIPT,
    :label_css => TYPE_CSS,
    :label_html => TYPE_HTML
  }

  INSERTION_POSITION_HTML_HEAD = "html_head"
  INSERTION_POSITION_HTML_BOTTOM = "html_bottom"
  INSERTION_POSITION_ISSUE_FORM = "issue_form"
  INSERTION_POSITION_ISSUE_SHOW = "issue_show"
  INSERTION_POSITION_ISSUES_CONTEXT_MENU = "issues_context_menu"

  @@insertion_positions = {
    :label_insertion_position_html_head => INSERTION_POSITION_HTML_HEAD,
    :label_insertion_position_issue_form => INSERTION_POSITION_ISSUE_FORM,
    :label_insertion_position_issue_show => INSERTION_POSITION_ISSUE_SHOW,
    :label_insertion_position_html_bottom => INSERTION_POSITION_HTML_BOTTOM,
    :label_insertion_position_issues_context_menu => INSERTION_POSITION_ISSUES_CONTEXT_MENU
  }

  def customize_types
    @@customize_types
  end

  def customize_type_label
    @@customize_types.key(customize_type)
  end

  def insertion_positions
    @@insertion_positions
  end

  def insertion_position_label
    @@insertion_positions.key(insertion_position)
  end

  def is_javascript?
    customize_type == TYPE_JAVASCRIPT
  end

  def is_css?
    customize_type == TYPE_CSS
  end

  def is_html?
    customize_type == TYPE_HTML
  end

  def available?(user=User.current)
    is_enabled && (!is_private || author == user)
  end

  def valid_pattern
    if path_pattern.present?
      begin
        Regexp.compile(path_pattern)
      rescue
        errors.add(:path_pattern, :invalid)
      end
    end

    if project_pattern.present?
      begin
        Regexp.compile(project_pattern)
      rescue
        errors.add(:project_pattern, :invalid)
      end
    end

  end

  def initialize(attributes=nil, *args)
    super
    if new_record?
      self.author = User.current
    end
  end
  
end
