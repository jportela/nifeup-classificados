module AdsHelper  
  
  def checked?(id)
    if params[":section_#{id}"]
      true
    else
      false
    end
  end  
  def date_format(value)
    return value.to_i if value.class == String
    return value if !value.acts_like_time?

    if value.to_date == Date.today
      return value.strftime "%H:%M"
    elsif value.year == Date.today.year
	  return value.strftime "%d %B"
    else
	  return value.strftime "%d %B %Y"
	end
  end
	
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end
end
