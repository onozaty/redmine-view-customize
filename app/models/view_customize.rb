class ViewCustomize < ActiveRecord::Base
  unloadable

  validates_presence_of :path_pattern
  validates_length_of :path_pattern, :maximum => 255

  validates_presence_of :code

  @@customize_types = {"JavaScript" => 1, "StyleSheet" => 2}

  def customize_types
    @@customize_types
  end

  def customize_type_name
    @@customize_types.key(customize_type)
  end
end
