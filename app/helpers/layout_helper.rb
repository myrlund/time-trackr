# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def tool(instances, action, options={}, &block)
    
    # Ensure instances is Array
    instances = [instances] unless instances.class == Array
    path_instances = instances.select { |inst| inst.class != Class }
    
    # Get model class for last instance
    model_class = instances.last.class == Class ? instances.last : instances.last.class
    
    # Get model names for all instances
    model_names = instances.collect { |inst| inst.class == Class ? inst.name.downcase : inst.class.name.downcase }
    
    # Put it all in CRUD block
    content_for :crud do
      render :partial => "shared/tool", :locals => {
        :text => T("#{model_class.name.downcase.pluralize}.#{action}"),           # -> projects.new
        :url => send("#{action}_#{model_names.join('_')}_path", path_instances),  # -> new_project_path
        :cls => "tool #{action} #{model_names.last}",                             # -> tool new project
        :block_contents => block_given? ? capture(&block) : nil,                  # Captures block into block_contents
      }
    end
  end
  
end
