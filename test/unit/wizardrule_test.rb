require File.dirname(__FILE__) + '/../test_helper'

class WizardruleTest < Test::Rails::TestCase
  fixtures :wizardrules, :wizards,:todos, :projects, :users, :contexts, :preferences, :tags, :taggings

  def setup
    @weekly = Wizardrule.find(1).reload
    @monthly = Wizardrule.find(2).reload
    @yearly = Wizardrule.find(3).reload
  end
  
  def test_load
    assert_kind_of WeeklyWizardrule, @weekly
    assert_kind_of MonthlyWizardrule, @monthly
    assert_kind_of YearlyWizardrule, @yearly
    assert_equal 1, @weekly.id
    assert_equal 1, @weekly.context_id
    assert_equal 3, @yearly.id
    assert_equal "aweeklyrule", @weekly.description
    assert @yearly.autoinsert
    assert_equal "vino vino vino", @monthly.notes
    assert_equal 3, @monthly.showdaysbefore
  end
  
  # Validation tests
  #
  def test_validate_presence_of_description
    assert_equal "aweeklyrule", @weekly.description
    @weekly.description = ""
    assert !@weekly.save
    assert_equal 1, @weekly.errors.count
    assert_equal "can't be blank", @weekly.errors.on(:description)
  end
  
  def test_validate_length_of_description
    assert_equal "amonthlyrule", @monthly.description
    @monthly.description = generate_random_string(101)
    assert !@monthly.save
    assert_equal 1, @monthly.errors.count
  end
  
  def test_validate_length_of_notes
    assert_equal "celebration generation", @yearly.notes
    @yearly.notes = generate_random_string(60001)
    assert !@yearly.save
    assert_equal 1, @yearly.errors.count
    assert_equal "is too long (maximum is 60000 characters)", @yearly.errors.on(:notes)
  end

  
end
