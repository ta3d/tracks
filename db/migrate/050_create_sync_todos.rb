class CreateSyncTodos < ActiveRecord::Migration
  def self.up
    create_table :sync_todos do |t|
      t.column "todo_id", :integer, :null => false
      t.column "user_id", :integer, :null => false 
      t.column "sync_vtodo_content", :text, :null => false
      t.column "sync_vcalendar_content", :text, :null => false
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
      t.column "version", :integer, :null => false, :default => 1
      t.column "deleted", :boolean, :null => false, :default => 0
    end
  end

  def self.down
    drop_table :sync_todos
  end
end
