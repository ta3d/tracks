class AddAutoinsertPreferences < ActiveRecord::Migration
    def self.up
      add_column :preferences, :autoinsert_weekly_inadvance, :integer, :null => false, :default => 1
      add_column :preferences, :autoinsert_monthly_inadvance, :integer, :null => false, :default => 1
      add_column :preferences, :autoinsert_yearly_inadvance, :integer, :null => false, :default => 1
    end

    def self.down
      remove_column :preferences, :autoinsert_weekly_inadvance
      remove_column :preferences, :autoinsert_monthly_inadvance
      remove_column :preferences, :autoinsert_yearly_inadvance
    end
end
