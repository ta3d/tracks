module WizardrulesHelper
  
  
  def project_and_context_links
    str = ''
    str << item_link_to_context( @wizardrule )
    if @wizardrule.project_id
        str << item_link_to_project( @wizardrule )
    end
    return str
  end
  
  def remote_delete_icon
    str = link_to( image_tag_for_delete,
      wizardrule_path(@wizardrule), :id => "delete_icon_"+@wizardrule.id.to_s,
      :class => "icon delete_icon", :title => "delete the rule '#{@wizardrule.description}'")
    apply_behavior '.item-container a.delete_icon:click', :prevent_default => true do |page|
      page.confirming "'Are you sure that you want to ' + this.title + '?'" do
        page << "itemContainer = this.up('.item-container'); itemContainer.startWaiting();"
        page << remote_to_href(:method => 'delete', :complete => "itemContainer.stopWaiting();")
      end
    end
    str
  end
  
  def project_names_for_autocomplete
    array_or_string_for_javascript( ['None'] + @projects.select{ |p| p.active? }.collect{|p| escape_javascript(p.name) } )
  end
  
  def context_names_for_autocomplete
    # #return array_or_string_for_javascript(['Create a new context']) if
    # @contexts.empty?
    array_or_string_for_javascript( @contexts.collect{|c| escape_javascript(c.name) } )
  end

  def number_to_ordinal(num)
    num = num.to_i
    if (10...31)===num
      "#{num}th"
    else
      g = %w{ th st nd rd th th th th th th }
      a = num.to_s
      c=a[-1..-1].to_i
      a + g[c]
    end
  end  

  private
  
  def image_tag_for_delete
    image_tag("blank.png", :title =>"Delete rule", :class=>"delete_item")
  end
  
  def image_tag_for_edit
    image_tag("blank.png", :title =>"Edit rule", :class=>"edit_item", :id=> dom_id(@wizardrule, 'edit_icon'))
  end
end
module WizardrulesHelper
  
  
  def project_and_context_links
    str = ''
    str << item_link_to_context( @wizardrule )
    if @wizardrule.project_id
        str << item_link_to_project( @wizardrule )
    end
    return str
  end
  
  def remote_delete_icon
    str = link_to( image_tag_for_delete,
      wizardrule_path(@wizardrule), :id => "delete_icon_"+@wizardrule.id.to_s,
      :class => "icon delete_icon", :title => "delete the rule '#{@wizardrule.description}'")
    apply_behavior '.item-container a.delete_icon:click', :prevent_default => true do |page|
      page.confirming "'Are you sure that you want to ' + this.title + '?'" do
        page << "itemContainer = this.up('.item-container'); itemContainer.startWaiting();"
        page << remote_to_href(:method => 'delete', :complete => "itemContainer.stopWaiting();")
      end
    end
    str
  end
  
  def project_names_for_autocomplete
    array_or_string_for_javascript( ['None'] + @projects.select{ |p| p.active? }.collect{|p| escape_javascript(p.name) } )
  end
  
  def context_names_for_autocomplete
    # #return array_or_string_for_javascript(['Create a new context']) if
    # @contexts.empty?
    array_or_string_for_javascript( @contexts.collect{|c| escape_javascript(c.name) } )
  end

  def number_to_ordinal(num)
    num = num.to_i
    if (10...31)===num
      "#{num}th"
    else
      g = %w{ th st nd rd th th th th th th }
      a = num.to_s
      c=a[-1..-1].to_i
      a + g[c]
    end
  end  

  private
  
  def image_tag_for_delete
    image_tag("blank.png", :title =>"Delete rule", :class=>"delete_item")
  end
  
  def image_tag_for_edit
    image_tag("blank.png", :title =>"Edit rule", :class=>"edit_item", :id=> dom_id(@wizardrule, 'edit_icon'))
  end
end
