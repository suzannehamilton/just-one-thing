require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  test "index should get the full list of tasks" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "new should be a valid page" do
    get :new
    assert_response :success
  end

  test "create should create a new task" do
    assert_difference('Task.count') do
      post :create, task: {title: 'Test title'}
    end
  end
end