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
    task = Task.new
    task.title = "Parent title"
    child = Task.new
    child.title = "Child title"
    child.parent = task

    task.save
    child.save

    assert_equal child, task.next_step
  end
end
