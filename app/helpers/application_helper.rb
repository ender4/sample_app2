module ApplicationHelper
  
  # Return a title on a per-page basis
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end

  # def pluralize_no_count( count, singular, plural = nil )
  #   return singular unless count == 1
  #   return plural unless plural.nil?
  #   return pluralize( singular )
  # end
end
