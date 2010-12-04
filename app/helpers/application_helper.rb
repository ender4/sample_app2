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

  def help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
    
    def help2
      Helper2.instance
    end

    class Helper2
      include Singleton
      include ActiveSupport::Inflector
    end
    
    def pluralize_no_count( count, singular, plural = nil )
      if count == 1
        singular
      elsif plural.nil?
        help2.pluralize( singular )
      else
        plural
      end        
    end
  end

end
