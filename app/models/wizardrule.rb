class Wizardrule < ActiveRecord::Base
  belongs_to :user
  belongs_to :context
  belongs_to :project
  belongs_to :wizard
  has_many :todos, :dependent => :destroy
  #this is done to assure that we only save inherited rules - Baseclass Wizardrule is only abstract
  validates_presence_of([:class])
  validates_presence_of :description
  validates_presence_of :context
  validates_presence_of :user
  validates_presence_of :wizard
  validates_presence_of :remindtime
  validates_length_of :description, :maximum => 100
  validates_length_of :notes, :maximum => 60000, :allow_nil => true 
end

class WeeklyWizardrule < Wizardrule 
  validates_presence_of(:cw_relativeday)
end

class MonthlyWizardrule < Wizardrule 
  #validates_presence_of(:cw_relativeday || :cw_exactday)
end

class YearlyWizardrule < Wizardrule 
  validates_presence_of((:cw_exactmonth || :cw_exactday))
end
