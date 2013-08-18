require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    sign_in :user, users(:regular_user)
  end

  test "index should get the full list of tasks" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "index should get sub-tasks under tasks" do
    get :index

    listed_tasks = assigns(:tasks)    
    assert listed_tasks.include?(tasks(:parent))
    assert listed_tasks.include?(tasks(:completedTask))

    parentTask = listed_tasks.detect { |t| t.id == tasks(:parent).id }
    completedTask = listed_tasks.detect { |t| t.id == tasks(:completedTask).id }

    assert_equal tasks(:parent).children.size, parentTask.children.size
    assert_equal tasks(:completedTask).children.size, completedTask.children.size
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
      assert_nil task.last_uncompleted_child, "Task '#{task.title}' with id #{task.id} was loaded even though it has uncompleted children"
    end
  end

  test "random task should return parent if sub-task is completed" do
    tasks(:subtask).completed = true
    tasks(:subtask).save
    get :random
    assert_response :success
  end

  test "complete action marks task as complete" do
    task = create_new_task

    post :complete, id: task.id
    task.reload

    assert task.completed
  end

  test "complete action redirects to home page" do
    task = create_new_task

    post :complete, id: task.id

    assert_redirected_to :controller => "welcome", :action => "index", :notice => "Task completed"
  end

  private
    def create_new_task
      task = Task.new
      task.title = "Task to be completed"
      task.save
      task
    end 
end