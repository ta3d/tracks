require File.dirname(__FILE__) + '/../test_helper'

class WizardTest < Test::Unit::TestCase
  fixtures :wizards

  def setup
    @weekly = Wizard.find(1).reload
    @monthly = Wizard.find(2).reload
    @yearly = Wizard.find(3).reload
  end
  
  def test_load
    assert_kind_of Wizard, @weekly
    assert_equal 1, @weekly.id
    assert_equal 2, @monthly.id
    assert_equal 3, @yearly.id
    assert_equal "WEEKLY", @weekly.identifier
  end
end
