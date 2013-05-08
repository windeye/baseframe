# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper

  def page_title(text=nil)
    return text unless text.blank?
  end

  def flash_messages
    flash.map do |name, msg|
      content_tag(:div, :id => "flash_#{name}") do
        content_tag(:div, msg, :class => 'message')
      end
    end.join(' ').html_safe
  end

end
