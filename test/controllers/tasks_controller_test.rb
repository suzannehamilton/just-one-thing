require 'test_helper'
require 'task_builder'

class TasksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    sign_in users(:regular_user)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "all list should get the full list of top-level tasks belonging to user" do
    get :all
    assert_response :success
    assert_not_nil assigns(:tasks)
    assert_equal 2, assigns(:tasks).count
  end

  test "all list should get sub-tasks under tasks" do
    get :all

    listed_tasks = assigns(:tasks)
    assert listed_tasks.include?(tasks(:parent))
    assert listed_tasks.include?(tasks(:completedTask))

    parentTask = listed_tasks.detect { |t| t.id == tasks(:parent).id }
    completedTask = listed_tasks.detect { |t| t.id == tasks(:completedTask).id }

    assert_equal tasks(:parent).children.size, parentTask.children.size
    assert_equal tasks(:completedTask).children.size, completedTask.children.size
  end

  test "all list shows no tasks if user has no tasks" do
    sign_in users(:user_with_no_tasks)
    get :all
    assert_equal [], assigns(:tasks)
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

  test "create should create a new task associated with user" do
    post :create, task: {title: "Test title"}
    assert_equal users(:regular_user), assigns(:task).user
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

  test "create_child should create a new sub-task associated with the current user" do
    post :create_child, child_task: {title: 'Test title'}, id: tasks(:parent).id
    assert_equal users(:regular_user), assigns(:child).user
  end

  test "create_child should redirect to new task page" do
    post :create_child, child_task: {title: 'Test title'}, id: tasks(:parent).id
    assert_redirected_to :controller => "tasks", :action => "new", :notice => "New child task created"
  end

  test "random task fetches uncompleted task associated with current user" do
    for random_task in 0..100
      get :random
      assert_response :success
      task = assigns(:task)
      assert_not_nil task, "Task is nil"
      refute task.completed, "Task '#{task.title}' with id #{task.id} was loaded even though it is completed"
      assert_nil task.last_uncompleted_child, "Task '#{task.title}' with id #{task.id} was loaded even though it has uncompleted children"
      assert_equal users(:regular_user), task.user
    end
  end

  test "random task should return parent if sub-task is completed" do
    tasks(:subtask).completed = true
    tasks(:subtask).save
    get :random
    assert_response :success
  end

  test "random task redirects to success page when there are no incomplete tasks" do
    sign_in users(:user_with_no_tasks)
    get :random
    assert_redirected_to :controller => "tasks", :action => "success", :notice => "All tasks completed"
  end

  test "complete action marks task as complete" do
    task = TaskBuilder.new.with_default_title.with_user.save

    post :complete, id: task.id
    task.reload

    assert task.completed
  end

  test "complete action redirects to home page" do
    task = TaskBuilder.new.with_default_title.with_user.save

    post :complete, id: task.id

    assert_redirected_to :controller => "tasks", :action => "index", :notice => "Task completed"
  end
end