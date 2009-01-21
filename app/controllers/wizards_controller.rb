class WizardsController < ApplicationController

  if Tracks::Config.openid_enabled?
     open_id_consumer
     before_filter  :begin_open_id_auth,    :only => :update_auth_type
  end

  before_filter :admin_login_required, :only => [ :index, :generate_weekly_todos, :generate_monthly_todos, :generate_yearly_todos , :autocomplete_generated_todos ]
  skip_before_filter :login_required, :only => [ :index, :generate_weekly_todos, :generate_monthly_todos, :generate_yearly_todos , :autocomplete_generated_todos ]
  prepend_before_filter :login_optional, :only => [ :index, :generate_weekly_todos, :generate_monthly_todos, :generate_yearly_todos , :autocomplete_generated_todos ]
  
  def index 
    @wizards = Wizard.find(:all)
  end
  
  def generate_weekly_todos
    MiddleMan.worker(:execute_calendar_wizard_worker).generate_weekly_todos
    respond_to do |format|
      format.js
      format.html { redirect_to :controller => "wizards", :action => "index" }
    end
  end
  
  def generate_monthly_todos
    MiddleMan.worker(:execute_calendar_wizard_worker).generate_monthly_todos
    respond_to do |format|
      format.js
      format.html { redirect_to :controller => "wizards", :action => "index" }
    end
  end
  
  def generate_yearly_todos
    MiddleMan.worker(:execute_calendar_wizard_worker).generate_yearly_todos
    respond_to do |format|
      format.js
      format.html { redirect_to :controller => "wizards", :action => "index" }
    end
  end 
  
  def autocomplete_generated_todos
    MiddleMan.worker(:autocomplete_generated_todos_worker).autocomplete
    respond_to do |format|
      format.js
      format.html { redirect_to :controller => "wizards", :action => "index" }
    end
  end 

end

class CalendarWizardsController < WizardsController

end