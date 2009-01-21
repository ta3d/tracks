class AddRemindtimeColumn < ActiveRecord::Migration
  def self.up
    add_column "todos", "remindtime", :datetime
    Todo.find(:all).each do |t|
      t.update_attribute :remindtime, t.due
    end
    add_column "wizardrules", "remindtime", :time
    Wizardrule.find(:all).each do |r|
      r.update_attribute :remindtime, Time.now
    end
  end

  def self.down
    remove_column "todos", "remindtime"
    remove_column "wizardrules", "remindtime"
  end
end