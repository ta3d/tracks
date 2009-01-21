class Wizard < ActiveRecord::Base
  has_many :wizardrules, :dependent => :delete_all
  WEEKLY="WEEKLY"
  MONTHLY="MONTHLY"
  YEARLY="YEARLY"
end
