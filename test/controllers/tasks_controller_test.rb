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

  test "create should redirect to page for creating a new task" do
    post :create, task: {title: 'Test title'}
    assert_redirected_to :controller => "tasks", :action => "new", :notice => "New task created"
  end

  test "create_child should create a new sub-task" do
    assert_difference('Task.count') do
      post :create_child, child_task: {title: 'Test title'}, id: tasks(:parent).id
    end
  end

  test "create_child should redirect to new task page" do
    post :create_child, child_task: {title: 'Test title'}, id: tasks(:parent).id
    assert_redirected_to :controller => "tasks", :action => "new", :notice => "New child task created"
  end

  test "random task fetches uncompleted task" do
    for random_task in 0..100
      get :random
      assert_response :success
      task = assigns(:task)
      assert_not_nil task, "Task is nil"
      refute task.completed, "Task '#{task.title}' with id #{task.id} was loaded even though it is completed"
    end
  end
end