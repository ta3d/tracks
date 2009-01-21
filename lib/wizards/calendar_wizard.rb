module CalendarWizard
  include SyncData
   def execute_weeklywizard_on_all_user
     User.find(:all).each do |user| 
       Wizardrule.find_all_by_wizard_id_and_user_id_and_autoinsert(Wizard.find_by_identifier(Wizard::WEEKLY),user,true).each do |wizardrule|
         generate_todos_from_weeklyrule(wizardrule,  user.prefs.autoinsert_weekly_inadvance*7)
       end
     end
   end
   
   def execute_monthlywizard_on_all_user
     User.find(:all).each do |user| 
       Wizardrule.find_all_by_wizard_id_and_user_id_and_autoinsert(Wizard.find_by_identifier(Wizard::MONTHLY),user,true).each do |wizardrule|
         generate_todos_from_monthlyrule(wizardrule,  user.prefs.autoinsert_monthly_inadvance)
       end
     end
   end
   
   def execute_yearlywizard_on_all_user
     User.find(:all).each do |user| 
       Wizardrule.find_all_by_wizard_id_and_user_id_and_autoinsert(Wizard.find_by_identifier(Wizard::YEARLY),user,true).each do |wizardrule|
         generate_todos_from_yearlyrule(wizardrule,  user.prefs.autoinsert_yearly_inadvance)
       end
     end
   end
   
   def generate_todos_from_weeklyrule(wizardrule,  days_in_advance)
     Todo.find_all_by_wizardrule_id(wizardrule).each do |todo|
       todo.destroy
     end
     dues = get_weekly_dues(wizardrule, Date.today, Date.today+days_in_advance)
     dues.each do |due|
       todo = build_todo(wizardrule)
       todo.due = due
       todo.remindtime = get_remindtime wizardrule,due
       todo.show_from = get_show_from(todo.due, wizardrule)
       saved = todo.save
       unless (saved == false) || wizardrule.tags.blank?
         user = User.find(wizardrule.user_id)
         todo.tag_with(wizardrule.tags, user)
         todo.tags.reload
       end
     end
     return dues.length
   end
   
   def generate_todos_from_monthlyrule(wizardrule,  months_in_advance)
     Todo.find_all_by_wizardrule_id(wizardrule).each do |todo|
       todo.destroy
     end
     enddate = Date.today 
     (1..months_in_advance).each {enddate = enddate.next_month.end_of_month}
     dues = get_monthly_dues(wizardrule, Date.today, enddate)
     if dues != nil
       dues.each do |due|
         todo = build_todo(wizardrule)
         todo.due = due
         todo.remindtime = get_remindtime wizardrule,due
         todo.show_from = get_show_from(todo.due, wizardrule)
         saved = todo.save
         unless (saved == false) || wizardrule.tags.blank?
           user = User.find(wizardrule.user_id)
           todo.tag_with(wizardrule.tags, user)
           todo.tags.reload
         end
       end
       return dues.length
     end
   end
   
   def generate_todos_from_yearlyrule(wizardrule,  years_in_advance)
     Todo.find_all_by_wizardrule_id(wizardrule).each do |todo|
       todo.destroy
     end
     enddate = Date.today 
     (1..years_in_advance*12).each {enddate = enddate.next_month.end_of_month}
     dues = get_yearly_dues(wizardrule, Date.today, enddate)
     if dues != nil
       dues.each do |due|
         todo = build_todo(wizardrule)
         todo.due = due
         todo.remindtime = get_remindtime wizardrule,due
         todo.show_from = get_show_from(todo.due, wizardrule)
         saved = todo.save
         unless (saved == false) || wizardrule.tags.blank?
           user = User.find(wizardrule.user_id)
           todo.tag_with(wizardrule.tags, user)
           todo.tags.reload
         end
       end
       return dues.length
     end
   end
 
   def build_todo(wizardrule)
     todo = Todo.new
     todo.user_id = wizardrule.user_id
     todo.context_id = wizardrule.context_id
     todo.wizardrule_id = wizardrule.id
     todo.project_id = wizardrule.project_id
     todo.notes = wizardrule.notes
     todo.description = wizardrule.description
     return todo
   end
   
   def get_weekly_dues(wizardrule, startdate , enddate)
     resultdates = Array.new
     if(wizardrule.cw_relativeday)
        startdate +=1 while (startdate.wday != wizardrule.cw_relativeday.to_i)
        startdate.step(enddate, 7) do |date|
          resultdates << date
        end
      end
      return resultdates 
    end
  
   def get_monthly_dues(wizardrule, startdate , enddate)
     resultdates = Array.new
     if wizardrule.cw_relativeday != nil
      relative = wizardrule.cw_relativeday
      day = wizardrule.cw_exactday
      if day==nil
        resultdates = monthly_relative_day(relative , startdate , enddate)
      else
        resultdates = monthly_relative_weekday(relative, day, startdate , enddate)
      end 
     else
      resultdates = monthly_exact_day(wizardrule.cw_exactday, startdate , enddate)
    end
    return resultdates 
   end

   def get_yearly_dues(wizardrule, startdate , enddate)
     resultdates = Array.new
     if wizardrule.cw_exactday != nil && wizardrule.cw_exactmonth != nil
      day = wizardrule.cw_exactday
      month = wizardrule.cw_exactmonth
      actual = Date.new(Date.today.year,month,day)
      while (actual > Date.today && actual < enddate )
        resultdates << actual 
        #add 12 months 
        actual = actual >> 12 
      end
     else
      
    end
    return resultdates 
   end
   
   #first or last day of the month
   def monthly_relative_day(relative, startdate , enddate)
     results = Array.new
     if relative=='LAST'
       actual = startdate
       while (actual.end_of_month <= enddate)
        results << actual.end_of_month
        puts actual.end_of_month
        actual = actual.next_month.beginning_of_month
      end
     elsif relative=='FIRST'
       actual = startdate
       if startdate.beginning_of_month < startdate 
          actual = startdate.next_month.beginning_of_month 
       end
       while (actual.beginning_of_month <= enddate)
        results << actual.beginning_of_month
        actual = actual.next_month.beginning_of_month
       end
     else 
       
     end
     return results
    end

   #first or last mo ,tue ...
   def monthly_relative_weekday(relative, weekday, startdate , enddate)
     results = Array.new
     if relative=='LAST'
       actual = startdate.end_of_month
       while (actual.end_of_month <= enddate)
        actual -=1 while (actual.wday != weekday)
        results << actual
        puts actual
        actual = actual.next_month.end_of_month
      end
     elsif relative=='FIRST'
       actual = startdate
       if startdate.beginning_of_month < startdate 
          actual = startdate.next_month.beginning_of_month 
       end
       while (actual.beginning_of_month <= enddate)
        actual +=1 while (actual.wday != weekday)
        results << actual
        actual = actual.next_month.beginning_of_month
       end
     else 
       
     end
     return results
   end 
   #e.g. 14th
   def monthly_exact_day(exact, startdate , enddate)
     results = Array.new
     if exact != nil 
      day = exact
      if day<Date.today.day
        month = Date.today.next_month.month
        actual = Date.new(Date.today.next_month.year,month,day)
      else 
        month = Date.today.month
        actual = Date.new(Date.today.year,month,day)
      end 
      while (actual >= Date.today && actual < enddate )
        results << actual 
        #add 12 months 
        actual = actual >> 1
       end
     end
     return results
    end
   
   def get_show_from(due, wizardrule)
     if (due&&wizardrule)
       show_from = due-wizardrule.showdaysbefore
       if show_from<Date.today
         return Date.today
       end
       return show_from 
     end
   end
  
   def get_remindtime(wizardrule,due)
     t=wizardrule.remindtime
     remindtime=Time.zone.local(due.year,due.month,due.day,t.hour,t.min,0)
     remindtime.utc
   end
  
end