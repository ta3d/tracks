require File.dirname(__FILE__) + '/../test_helper'
require 'wizardrules_controller'

# Re-raise errors caught by the controller.
class WeeklyWizardrulesController; def rescue_action(e) raise e end; end

class WeeklyWizardrulesControllerTest < Test::Rails::TestCase
  fixtures :users, :wizards, :wizardrules ,:preferences, :projects, :contexts, :todos, :tags, :taggings
  def setup
    @controller = WeeklyWizardrulesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_create
    login_as(:admin_user)
    #autoinsert/autocomplete is default true
    put :create, "cw_relativeday"=>"1",  "context_name"=>"library", "project_name"=>"Build a working time machine", "wizardrule"=>{"notes"=>"", "description"=>"Call Warren Buffet to find out how much he makes per day", 'showdaysbefore' => 3}, "tag_list"=>"foo bar" 
    assert_equal 4, assigns['weeklyWizardrule'].id
    assert_not_nil assigns['contexts']
    Todo.find_all_by_wizardrule_id(4).each do |todo|
      assert_equal 1, todo.due.wday
    end  
  end
  
  def test_update_rule_change_context
    login_as(:admin_user)
    xhr :post, :update, :id => 1, "cw_relativeday"=>"2",  "context_name"=>"newcontext", "project_name"=>"Build a working time machine", "wizardrule"=>{"notes"=>"", "description"=>"Call Warren Buffet to find out how much he makes per day", 'showdaysbefore' => 3}, "tag_list"=>"foo bar" 
    assert_equal 1, assigns['wizardrule'].id
    assert_equal 'newcontext', assigns['wizardrule'].context.name
    assert_not_nil assigns['contexts']
    Todo.find_all_by_wizardrule_id(1).each do |todo|
      assert_equal 2, todo.due.wday
    end  
  end
end
