require File.dirname(__FILE__) + '/../test_helper'
require 'wizardrules_controller'

# Re-raise errors caught by the controller.
class YearlyWizardrulesController; def rescue_action(e) raise e end; end

class YearlyWizardrulesControllerTest < Test::Rails::TestCase
  fixtures :users, :wizards, :wizardrules ,:preferences, :projects, :contexts, :todos, :tags, :taggings

  def setup
    @controller = YearlyWizardrulesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_create
    login_as(:admin_user)
    #autoinsert/autocomplete is default true
    put :create, "cw_exactday"=>"3", "cw_exactmonth"=>"11", "context_name"=>"library", "project_name"=>"Build a working time machine", "wizardrule"=>{"notes"=>"", "description"=>"Call Warren Buffet to find out how much he makes per day", 'showdaysbefore' => 3}, "tag_list"=>"foo bar" 
    assert_equal 4, assigns['yearlyWizardrule'].id
    assert_not_nil assigns['contexts']
    Todo.find_all_by_wizardrule_id(4).each do |todo|
      assert_equal 3, todo.due.day
      assert_equal 11, todo.due.month
    end  
  end
  
  def test_update_rule_change_context
    login_as(:admin_user)
    xhr :post, :update, :id => 3, "cw_exactday"=>"3", "cw_exactmonth"=>"11",  "context_name"=>"newcontext", "project_name"=>"Build a working time machine", "wizardrule"=>{"notes"=>"", "description"=>"Call Warren Buffet to find out how much he makes per day", 'showdaysbefore' => 3}, "tag_list"=>"foo bar" 
    assert_equal 3, assigns['wizardrule'].id
    assert_equal 'newcontext', assigns['wizardrule'].context.name
    assert_not_nil assigns['contexts']
    Todo.find_all_by_wizardrule_id(3).each do |todo|
      assert_equal 3, todo.due.day
      assert_equal 11, todo.due.month
    end  
  end
end
