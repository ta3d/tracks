class ExecuteCalendarWizardWorker < BackgrounDRb::MetaWorker
  include CalendarWizard
  set_worker_name :execute_calendar_wizard_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  def generate_weekly_todos()
    puts "..executing worker weekly"
    execute_weeklywizard_on_all_user
  end
  def generate_monthly_todos()
    puts "..executing worker monthly"
    execute_monthlywizard_on_all_user
  end
  def generate_yearly_todos()
    puts "..executing worker yearly"
    execute_yearlywizard_on_all_user
  end
end

