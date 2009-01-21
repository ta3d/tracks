module YearlyWizardrulesHelper
    def form_remote_tag_edit_yearly_wizardrule( &block )
    form_tag( 
      yearly_wizardrule_path(@wizardrule), {
        :method => :put, 
        :id => dom_id(@wizardrule, 'form'), 
        :class => dom_id(@wizardrule, 'form') + " inline-form edit_wizardrule_form" }, 
      &block )
    apply_behavior 'form.edit_wizardrule_form', make_remote_form(
      :method => :put, 
    :before => "$('yearly-wizard-update-rule-submit').startWaiting()",
    :complete => "$('yearly-wizard-update-rule-submit').stopWaiting()",
    :condition => "!$('yearly-wizard-update-rule-submit').isWaiting()"),
    :prevent_default => true
  end
   
  def remote_yearly_edit_icon
    str = link_to( image_tag_for_edit,
      edit_yearly_wizardrule_path(@wizardrule),
      :class => "icon edit_icon")
    apply_behavior '.item-container a.edit_icon:click', :prevent_default => true do |page|
      page << "Effect.Pulsate(this);"
      page << remote_to_href(:method => 'get')
    end

    str
  end
  
  def yearly_rule_pattern
      str = @wizardrule.cw_exactday.to_s+". "+WizardrulesController::MONTHS.index(@wizardrule.cw_exactmonth)
      return str
  end
end
module YearlyWizardrulesHelper
    def form_remote_tag_edit_yearly_wizardrule( &block )
    form_tag( 
      yearly_wizardrule_path(@wizardrule), {
        :method => :put, 
        :id => dom_id(@wizardrule, 'form'), 
        :class => dom_id(@wizardrule, 'form') + " inline-form edit_wizardrule_form" }, 
      &block )
    apply_behavior 'form.edit_wizardrule_form', make_remote_form(
      :method => :put, 
    :before => "$('yearly-wizard-update-rule-submit').startWaiting()",
    :complete => "$('yearly-wizard-update-rule-submit').stopWaiting()",
    :condition => "!$('yearly-wizard-update-rule-submit').isWaiting()"),
    :prevent_default => true
  end
   
  def remote_yearly_edit_icon
    str = link_to( image_tag_for_edit,
      edit_yearly_wizardrule_path(@wizardrule),
      :class => "icon edit_icon")
    apply_behavior '.item-container a.edit_icon:click', :prevent_default => true do |page|
      page << "Effect.Pulsate(this);"
      page << remote_to_href(:method => 'get')
    end

    str
  end
  
  def yearly_rule_pattern
      str = @wizardrule.cw_exactday.to_s+". "+WizardrulesController::MONTHS.index(@wizardrule.cw_exactmonth)
      return str
  end
end
