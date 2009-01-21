module ContextsHelper

  def get_listing_sortable_options
    {
      :tag => 'div',
      :handle => 'handle',
      :complete => visual_effect(:highlight, 'list-contexts'),
      :url => order_contexts_path
    }
  end
  
  def context_tag_list_text
    @context.tags.collect{|t| t.name}.join(', ')
  end

end
