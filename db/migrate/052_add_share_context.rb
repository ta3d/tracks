class AddShareContext < ActiveRecord::Migration
  def self.up
#    create_table "shared_contexts", :force => true do |t|
#      t.column "origin_context_id", :integer, :null => false
#      t.column "destination_context_id", :integer, :null => false
#      t.column "created_at", :timestamp
#      t.column "updated_at", :timestamp
#    end   
    create_table "invites", :force => true do |t|
      t.column "context_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
    end
    add_column "todos", "shared_origin_todo_id", :integer
    add_column "contexts", "context_id", :integer
    add_column "contexts", "sharemodus", :integer, :null => false, :default => 0
    Context.find(:all).each do |c|
      c.update_attribute :sharemodus, 0
    end
  end

  def self.down
    remove_column "todos", "shared_origin_todo_id"
    remove_column "contexts", "sharemodus"
    remove_column "contexts", "context_id"
    drop_table "invites"
    #drop_table "shared_contexts"
  end
end