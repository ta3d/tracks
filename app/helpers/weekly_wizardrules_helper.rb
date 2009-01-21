module WeeklyWizardrulesHelper
   
  def form_remote_tag_edit_weekly_wizardrule( &block )
    form_tag( 
      weekly_wizardrule_path(@wizardrule), {
        :method => :put, 
        :id => dom_id(@wizardrule, 'form'), 
        :class => dom_id(@wizardrule, 'form') + " inline-form edit_wizardrule_form" }, 
      &block )
    apply_behavior 'form.edit_wizardrule_form', make_remote_form(
      :method => :put, 
    :before => "$('weekly-wizard-update-rule-submit').startWaiting()",
    :complete => "$('weekly-wizard-update-rule-submit').stopWaiting()",
    :condition => "!$('weekly-wizard-update-rule-submit').isWaiting()"),
    :prevent_default => true
  end
   
  def remote_weekly_edit_icon
    str = link_to( image_tag_for_edit,
      edit_weekly_wizardrule_path(@wizardrule),
      :class => "icon edit_icon")
    apply_behavior '.item-container a.edit_icon:click', :prevent_default => true do |page|
      page << "Effect.Pulsate(this);"
      page << remote_to_href(:method => 'get')
    end

    str
  end
  
  def weekly_rule_pattern
    return WizardrulesController::DAYS.index(@wizardrule.cw_relativeday.to_i)
  end
end
module WeeklyWizardrulesHelper
   
  def form_remote_tag_edit_weekly_wizardrule( &block )
    form_tag( 
      weekly_wizardrule_path(@wizardrule), {
        :method => :put, 
        :id => dom_id(@wizardrule, 'form'), 
        :class => dom_id(@wizardrule, 'form') + " inline-form edit_wizardrule_form" }, 
      &block )
    apply_behavior 'form.edit_wizardrule_form', make_remote_form(
      :method => :put, 
    :before => "$('weekly-wizard-update-rule-submit').startWaiting()",
    :complete => "$('weekly-wizard-update-rule-submit').stopWaiting()",
    :condition => "!$('weekly-wizard-update-rule-submit').isWaiting()"),
    :prevent_default => true
  end
   
  def remote_weekly_edit_icon
    str = link_to( image_tag_for_edit,
      edit_weekly_wizardrule_path(@wizardrule),
      :class => "icon edit_icon")
    apply_behavior '.item-container a.edit_icon:click', :prevent_default => true do |page|
      page << "Effect.Pulsate(this);"
      page << remote_to_href(:method => 'get')
    end

    str
  end
  
  def weekly_rule_pattern
    return WizardrulesController::DAYS.index(@wizardrule.cw_relativeday.to_i)
  end
end
