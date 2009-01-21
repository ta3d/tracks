require 'calendar_wizard'
class WizardrulesController < ApplicationController
    include CalendarWizard
    
  MONTHS = { 'January' => 1, 'February' => 2, 'March' => 3, 'April' => 4, 'May' => 5, 'June' => 6, 'July' => 7, 
             'August' => 8, 'September'=> 9, 'October' =>10, 'November' =>11, 'December' =>12 }
  MONTHS_WITHOUT_FEB = { 'January' => 1, 'March' => 3, 'April' => 4, 'May' => 5, 'June' => 6, 'July' => 7, 
              'August' => 8, 'September'=> 9, 'October' =>10, 'November' =>11, 'December' =>12 }
  MONTHS_WITH_31DAYS = { 'January' => 1, 'March' => 3, 'May' => 5, 'July' => 7, 
              'August' => 8, 'October' =>10, 'December' =>12 }
  DAYS = {'Sunday' => 0, 'Monday' => 1, 'Tuesday' => 2, 'Wednesday'=> 3, 'Thursday' => 4, 'Friday' => 5, 'Saturday' => 6}
  FIRST = 'FIRST'
  LAST = 'LAST'
  
    
  helper :wizardrules
  helper :weekly_wizardrules
  helper :monthly_wizardrules
  helper :yearly_wizardrules
  
  before_filter :load_params, :only => [:create]
  before_filter :load_response_instance_vars, :only => [:index, :create, :edit, :update]
  append_before_filter :get_wizardrule_from_params, :only => [ :edit, :update, :destroy]

  
  def index
   respond_to do |format|
      format.html  &render_wizards_html
      #format.m     &render_todos_mobile
      #format.xml   { render :xml => @todos.to_xml( :except => :user_id ) }
      #format.rss   &render_rss_feed
      #format.atom  &render_atom_feed
      #format.text  &render_text_feed
      #format.ics   &render_ical_feed
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @saved = @wizardrule.destroy
    respond_to do |format|
      
      format.html do
        if @saved
          notify :notice, "Successfully deleted next rule", 2.0
          redirect_to :action => 'index'
        else
          notify :error, "Failed to delete the rule", 2.0
          redirect_to :action => 'index'
        end
      end  
      
      format.js do
        render
      end
    
    end
  end

  
  private
    def render_wizards_html
     lambda do
       @page_title = "TRACKS::Wizards for Automatic Context Assistance"

       render
      end
    end

    def load_params
      #load base wizardrule params
      attributes = params['request'] && params['request']['wizardrule']  || params['wizardrule']
      @generalParams = WizardCreateParamsHelper.new(params, prefs, attributes, current_user)
    end

    def load_response_instance_vars
      @wizards = Wizard.find(:all)
      @wizardrules = current_user.wizardrules
      @contexts = current_user.contexts
      @projects = current_user.projects.find(:all)
      @contexts_to_show = @contexts.reject {|x| x.hide? }
    end

    def get_wizardrule_from_params
          @wizardrule = current_user.wizardrules.find(params['id'])
    end 

    def update_standard_wizardrule_attribs
    @original_item_context_id = @wizardrule.context_id
    @original_item_project_id = @wizardrule.project_id
    if params['wizardrule']['project_id'].blank? && !params['project_name'].nil?
      if params['project_name'] == 'None'
        project = Project.null_object
      else
        project = current_user.projects.find_by_name(params['project_name'].strip)
        unless project
          project = current_user.projects.build
          project.name = params['project_name'].strip
          project.save
          @new_project_created = true
        end
      end
      params["wizardrule"]["project_id"] = project.id
    end
    
    if params['wizardrule']['context_id'].blank? && !params['context_name'].blank?
      context = current_user.contexts.find_by_name(params['context_name'].strip)
      unless context
        context = current_user.contexts.build
        context.name = params['context_name'].strip
        context.save
        @new_context_created = true
      end
      params["wizardrule"]["context_id"] = context.id
    end

    params['wizardrule']['autocomplete'] ||= false
    params['wizardrule']['autoinsert'] ||= false 
    
    params['wizardrule']['remindtime'] = Time.gm(2000,"jan",1,params['remindtimehour'].to_i,params['remindtimemin'].to_i,0)

    @saved = @wizardrule.update_attributes params["wizardrule"]
    @context_changed = @original_item_context_id != @wizardrule.context_id
    @project_changed = @original_item_project_id != @wizardrule.project_id
  end

class WizardCreateParamsHelper
      def initialize(params, prefs ,attribs, current_user)
        @params = params['request'] || params
        @prefs = prefs
        @attributes = attribs
        @attributes['user_id'] = current_user.id
        @attributes['remindtime'] = Time.gm(2000,"jan",1,@params['remindtimehour'].to_i,@params['remindtimemin'].to_i,0)
        if (project_specified_by_name?)
          project = current_user.projects.find_or_create_by_name(project_name)
          @new_project_created = project.new_record_before_save?
          @attributes['project_id'] = project.id
          @project_id = project.id
        end
        if (context_specified_by_name?)
          context = current_user.contexts.find_or_create_by_name(context_name)
          @new_context_created = context.new_record_before_save?
          @attributes['context_id'] = context.id
          @context_id = context.id
        end
      end
      
      def attributes
        @attributes
      end
      
      def project_name
        @params['project_name'].strip unless @params['project_name'].nil?
      end
      
      def context_name
        @params['context_name'].strip unless @params['context_name'].nil?
      end

      def project_id
        @project_id
      end
      
      def context_id
        @context_id
      end
      
      def tags
        @params['tags']
      end
      
      def autocomplete
        @params['autocomplete']
      end
      
      def autoinsert
        @params['autoinsert']
      end
      
      def showdaysbefore
        @params['showdaysbefore']
      end

      def project_specified_by_name?
        return false if project_name.blank?
        return false if project_name == 'None'
        true
      end
      
      def context_specified_by_name?
        return false if context_name.blank?
        true
      end
end
end   

class WeeklyWizardrulesController < WizardrulesController
  def create 
    @weeklyWizardrule = WeeklyWizardrule.new(@generalParams.attributes)
    @weeklyWizardrule.wizard_id = Wizard.find_by_identifier(Wizard::WEEKLY).id
    @weeklyWizardrule.cw_relativeday = params['cw_relativeday']
    #set rest to null
    @weeklyWizardrule.cw_exactday = nil
    @weeklyWizardrule.cw_exactmonth = nil
    @weeklyWizardrule.cw_relativemonth = nil
    @weeklyWizardrule.cw_relativeweek = nil
    @weeklyWizardrule.cw_exactweek = nil
    @saved = @weeklyWizardrule.save
    @number_of_generated_todos = generate_todos_from_weeklyrule(@weeklyWizardrule,7+(prefs.autoinsert_weekly_inadvance*7)) if @saved==true && @weeklyWizardrule.autoinsert?
    respond_to do |format|
      format.html { redirect_to :controller => "wizardrules", :action => "index" }
      format.js
    end 
  end
  
  def update
    update_standard_wizardrule_attribs  
    @wizardrule.cw_relativeday = params['cw_relativeday']
    #set rest to null
    @wizardrule.cw_exactday = nil
    @wizardrule.cw_exactmonth = nil
    @wizardrule.cw_relativemonth = nil
    @wizardrule.cw_relativeweek = nil
    @wizardrule.cw_exactweek = nil
    @saved = @wizardrule.save
    @number_of_generated_todos = generate_todos_from_weeklyrule(@wizardrule,7+(prefs.autoinsert_weekly_inadvance*7)) if @saved==true && @wizardrule.autoinsert?
    respond_to do |format|
      format.js
      format.html { redirect_to :controller => "wizardrules", :action => "index" }
    end
  end

end

class MonthlyWizardrulesController < WizardrulesController
  def create 
    @monthlyWizardrule = MonthlyWizardrule.new(@generalParams.attributes)
    @monthlyWizardrule.wizard_id = Wizard.find_by_identifier(Wizard::MONTHLY).id
    monthlyday=params['monthlyday']
    exactday=params['exactday']  
    if(monthlyday==LAST||monthlyday==FIRST )
      @monthlyWizardrule.cw_relativeday = params['monthlyday']
      @monthlyWizardrule.cw_exactday = nil
    else 
      @monthlyWizardrule.cw_exactday = params['monthlyday']
      @monthlyWizardrule.cw_relativeday = nil
    end 
    if(exactday!= nil && exactday!='' && exactday!='DAY')
      @monthlyWizardrule.cw_exactday = params['exactday']
    end
    #set rest to null
    @monthlyWizardrule.cw_exactmonth = nil
    @monthlyWizardrule.cw_relativemonth = nil
    @monthlyWizardrule.cw_relativeweek = nil
    @monthlyWizardrule.cw_exactweek = nil
    @saved = @monthlyWizardrule.save
    @number_of_generated_todos = generate_todos_from_monthlyrule(@monthlyWizardrule,prefs.autoinsert_monthly_inadvance) if @saved==true && @monthlyWizardrule.autoinsert?
    respond_to do |format|
      format.html { redirect_to :controller => "wizardrules", :action => "index" }
      format.js do
        render 
      end
    end 
  end
  def calculate_relativeweeks
    daynumber=params['daynumber']
    if daynumber=='LAST'||daynumber=='FIRST'
      render :update do |page|
        page.replace_html "cw_relativeweek_cont" , select_tag( "exactday", "<option value='DAY' >day</option>"+ options_for_select(DAYS,"Monday"))
      end
    else 
      render :update do |page|
      page.replace_html "cw_relativeweek_cont", "<a></a>"
      end
    end
  end
  def update
    update_standard_wizardrule_attribs  
    monthlyday=params['monthlyday']
    exactday=params['exactday']  
    if(monthlyday==LAST||monthlyday==FIRST )
      @wizardrule.cw_relativeday = params['monthlyday']
      @wizardrule.cw_exactday = nil
    else 
      @wizardrule.cw_exactday = params['monthlyday']
      @wizardrule.cw_relativeday = nil
    end 
    if(exactday!= nil && exactday!='' && exactday!='DAY')
      @wizardrule.cw_exactday = params['exactday']
    end
    #set rest to null
    @wizardrule.cw_exactmonth = nil
    @wizardrule.cw_relativemonth = nil
    @wizardrule.cw_relativeweek = nil
    @wizardrule.cw_exactweek = nil
    @saved = @wizardrule.save
    @number_of_generated_todos = generate_todos_from_monthlyrule(@wizardrule,prefs.autoinsert_monthly_inadvance) if @saved==true && @wizardrule.autoinsert?
    respond_to do |format|
      format.html { redirect_to :controller => "wizardrules", :action => "index" }
      format.js
    end 
  end
end

class YearlyWizardrulesController < WizardrulesController
  def create 
    @yearlyWizardrule = YearlyWizardrule.new(@generalParams.attributes)
    @yearlyWizardrule.wizard_id = Wizard.find_by_identifier(Wizard::YEARLY).id
    @yearlyWizardrule.cw_exactday = params['cw_exactday']
    @yearlyWizardrule.cw_exactmonth = params['cw_exactmonth']
    #set rest to null
    @yearlyWizardrule.cw_relativeday = nil
    @yearlyWizardrule.cw_relativemonth = nil
    @yearlyWizardrule.cw_relativeweek = nil
    @yearlyWizardrule.cw_exactweek = nil
    
    @saved = @yearlyWizardrule.save
    @number_of_generated_todos = generate_todos_from_yearlyrule(@yearlyWizardrule,prefs.autoinsert_yearly_inadvance) if @saved==true && @yearlyWizardrule.autoinsert?
    respond_to do |format|
      format.html { redirect_to :controller => "wizardrules", :action => "index" }
      format.js do
        render 
      end
    end 
  end
  def calculate_months
    daynumber=params['daynumber']
    if daynumber.to_i>29
      if daynumber.to_i>29 && daynumber.to_i<31
        render :update do |page|
          page.replace_html "cw_exactmonth", options_for_select(MONTHS_WITHOUT_FEB,"January") 
        end
      else 
        render :update do |page|
          page.replace_html "cw_exactmonth", options_for_select(MONTHS_WITH_31DAYS,"January") 
        end
      end
    else 
      render :update do |page|
      page.replace_html "cw_exactmonth", options_for_select(MONTHS,"January") 
      end
    end
  end
  def update
    update_standard_wizardrule_attribs  
    @wizardrule.cw_exactday = params['cw_exactday']
    @wizardrule.cw_exactmonth = params['cw_exactmonth']
    #set rest to null
    @wizardrule.cw_relativeday = nil
    @wizardrule.cw_relativemonth = nil
    @wizardrule.cw_relativeweek = nil
    @wizardrule.cw_exactweek = nil
    @saved = @wizardrule.save
    @number_of_generated_todos = generate_todos_from_yearlyrule(@wizardrule,prefs.autoinsert_yearly_inadvance) if @saved==true && @wizardrule.autoinsert?
    respond_to do |format|
      format.html { redirect_to :controller => "wizardrules", :action => "index" }
      format.js 
    end 
  end
 end



