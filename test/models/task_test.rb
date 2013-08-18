require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "should not save task without title" do
    task = Task.new
    refute task.save, "Saved the task without a title"
  end

  test "should save task with a title" do
    task = Task.new
    task.title = "Test title"
    assert task.save, "Did not save task"
  end

  test "task should be uncompleted by default" do
    task = Task.new
    task.save
    refute task.completed
  end

  test "task has no parent by default" do
    task = Task.new
    assert_nil task.parent
  end

  test "task has no children by default" do
    task = Task.new
    assert_equal 0, task.children.size
  end

  test "without_parent should return top-level tasks" do
    tasks_without_parents = Task.without_parent
    assert_equal 2, tasks_without_parents.size
  end

  test "uncompleted should return uncompleted tasks" do
    uncompleted_tasks = Task.uncompleted
    assert_equal 2, uncompleted_tasks.size
  end

  test "next step of a task with no children returns itself" do
    task = Task.new
    next_step = task.next_step
    assert_equal task, next_step
  end

  test "next step of a task with a single child returns the child" do
    task = create_task
    child = create_child task

    assert_equal task.children.last, task.next_step
  end

  test "next step with multiple children returns the last child" do
    task = create_task
    first_child = create_completed_child task
    second_child = create_child task

    assert_equal second_child, task.next_step
  end

  test "next step of task with child hierarchy returns last child" do
    task = create_task
    child = create_child task
    grandchild = create_child child

    assert_equal grandchild, task.next_step
  end

  def create_task
    task = Task.new
    task.title = "Test task"
    task.save
    return task
  end

  def create_child parent
    child = Task.new
    child.title = "Child of #{parent.title}"
    child.parent = parent
    child.save
    return child
  end

  def create_completed_child parent
    child = create_child parent
    child.completed = true
  end
end
