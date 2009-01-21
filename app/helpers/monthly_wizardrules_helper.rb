module MonthlyWizardrulesHelper
  def form_remote_tag_edit_monthly_wizardrule( &block )
    form_tag( 
      monthly_wizardrule_path(@wizardrule), {
        :method => :put, 
        :id => dom_id(@wizardrule, 'form'), 
        :class => dom_id(@wizardrule, 'form') + " inline-form edit_wizardrule_form" }, 
      &block )
    apply_behavior 'form.edit_wizardrule_form', make_remote_form(
      :method => :put, 
    :before => "$('monthly-wizard-update-rule-submit').startWaiting()",
    :complete => "$('monthly-wizard-update-rule-submit').stopWaiting()",
    :condition => "!$('monthly-wizard-update-rule-submit').isWaiting()"),
    :prevent_default => true
  end
   
  def remote_monthly_edit_icon
    str = link_to( image_tag_for_edit,
      edit_monthly_wizardrule_path(@wizardrule),
      :class => "icon edit_icon")
    apply_behavior '.item-container a.edit_icon:click', :prevent_default => true do |page|
      page << "Effect.Pulsate(this);"
      page << remote_to_href(:method => 'get')
    end

    str
  end
  
  def monthly_rule_pattern
    if @wizardrule.cw_relativeday != nil
      day = @wizardrule.cw_exactday == nil ? "day" : WizardrulesController::DAYS.index(@wizardrule.cw_exactday.to_i)
      str = @wizardrule.cw_relativeday.to_s+" "+day
      return str
    else
      return number_to_ordinal(@wizardrule.cw_exactday)
    end
  end
  
end
module MonthlyWizardrulesHelper
  def form_remote_tag_edit_monthly_wizardrule( &block )
    form_tag( 
      monthly_wizardrule_path(@wizardrule), {
        :method => :put, 
        :id => dom_id(@wizardrule, 'form'), 
        :class => dom_id(@wizardrule, 'form') + " inline-form edit_wizardrule_form" }, 
      &block )
    apply_behavior 'form.edit_wizardrule_form', make_remote_form(
      :method => :put, 
    :before => "$('monthly-wizard-update-rule-submit').startWaiting()",
    :complete => "$('monthly-wizard-update-rule-submit').stopWaiting()",
    :condition => "!$('monthly-wizard-update-rule-submit').isWaiting()"),
    :prevent_default => true
  end
   
  def remote_monthly_edit_icon
    str = link_to( image_tag_for_edit,
      edit_monthly_wizardrule_path(@wizardrule),
      :class => "icon edit_icon")
    apply_behavior '.item-container a.edit_icon:click', :prevent_default => true do |page|
      page << "Effect.Pulsate(this);"
      page << remote_to_href(:method => 'get')
    end

    str
  end
  
  def monthly_rule_pattern
    if @wizardrule.cw_relativeday != nil
      day = @wizardrule.cw_exactday == nil ? "day" : WizardrulesController::DAYS.index(@wizardrule.cw_exactday.to_i)
      str = @wizardrule.cw_relativeday.to_s+" "+day
      return str
    else
      return number_to_ordinal(@wizardrule.cw_exactday)
    end
  end
  
end
