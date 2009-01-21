class AddWizards < ActiveRecord::Migration
  def self.up
    create_table "wizards", :force => true do |t|
      t.column "name", :string
      t.column "description", :string
      t.column "identifier", :string
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
    end
    #insert the calendarwizards
    Wizard.create :name =>'weekly', :description =>'water the plants, rubbish, ...',:identifier =>'WEEKLY'
    Wizard.create :name =>'monthly', :description =>'pay the bills, check money, ...',:identifier =>'MONTHLY'
    Wizard.create :name =>'yearly', :description =>'birthdays, wedding days, ...', :identifier =>'YEARLY'
  end

  def self.down
    drop_table "wizards"
  end
end