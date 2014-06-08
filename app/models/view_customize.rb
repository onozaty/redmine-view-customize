class ViewCustomize < ActiveRecord::Base
  unloadable

  validates_presence_of :path_pattern
  validates_length_of :path_pattern, :maximum => 255

  validates_presence_of :code

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
  
end
