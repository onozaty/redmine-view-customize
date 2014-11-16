

class ViewCustomize < ActiveRecord::Base
  unloadable

  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  validates_presence_of :path_pattern
  validates_length_of :path_pattern, :maximum => 255

  validates_presence_of :code

  validate :valid_pattern

  TYPE_JAVASCRIPT = 1
  TYPE_STYLESHEET = 2

  @@customize_types = {
    "JavaScript" => TYPE_JAVASCRIPT,
    "StyleSheet" => TYPE_STYLESHEET
  }

  def customize_types
    @@customize_types
  end

  def customize_type_name
    @@customize_types.key(customize_type)
  end

  def is_javascript?
    customize_type == TYPE_JAVASCRIPT
  end

  def is_stylesheet?
    customize_type == TYPE_STYLESHEET
  end

  def available?(user=User.current)
    is_enabled && (!is_private || author == user)
  end

  def valid_pattern
    begin
      Regexp.compile(path_pattern)
    rescue
      errors.add(:path_pattern, :invalid)
    end
  end

  def initialize(attributes=nil, *args)
    super
    if new_record?
      self.author = User.current
    end
  end
  
end
