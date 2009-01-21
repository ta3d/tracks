class AddWizardrules < ActiveRecord::Migration
  def self.up
    create_table "wizardrules", :force => true do |t|
      t.column "cw_exactmonth", :integer
      t.column "cw_relativemonth", :string
      t.column "cw_exactweek", :integer
      t.column "cw_relativeweek", :string
      t.column "cw_exactday", :integer
      t.column "cw_relativeday", :string
      t.column "type", :string
      t.column "description", :string, :null => false 
      t.column "notes", :text
      t.column "wizard_id", :integer, :null => false 
      t.column "user_id", :integer, :null => false 
      t.column "context_id", :integer, :null => false
      t.column "project_id", :integer
      t.column "tags", :string
      t.column "showdaysbefore", :integer 
      t.column "autocomplete", :boolean, :default => false, :null => false
      t.column "autoinsert", :boolean, :default => false, :null => false
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
    end   
    add_column "todos", "wizardrule_id", :integer
  end

  def self.down
    remove_column "todos", "wizardrule_id"
    drop_table "wizardrules"
  end
end