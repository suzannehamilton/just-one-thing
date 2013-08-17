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
    assert task.children.size == 0
  end
end
