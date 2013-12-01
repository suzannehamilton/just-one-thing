require 'test_helper'
require 'task_builder'

class TaskTest < ActiveSupport::TestCase
  test "should not save task without title" do
    task = TaskBuilder.new.build
    refute task.save, "Saved the task without a title"
  end

  test "should save task with a title" do
    task = TaskBuilder.new.with_title("Test title").build
    assert task.save, "Did not save task"
  end

  test "task should be uncompleted by default" do
    task = Task.new
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
    task = TaskBuilder.new.with_default_title.build
    child = TaskBuilder.new.with_default_title.with_parent(task).save

    assert_equal task.children.last, task.next_step
  end

  test "next step with multiple children returns the last child" do
    task = TaskBuilder.new.with_default_title.build
    first_child = TaskBuilder.new.with_default_title.with_parent(task).completed.save
    second_child = TaskBuilder.new.with_default_title.with_parent(task).save

    assert_equal second_child, task.next_step
  end

  test "next step of task with child hierarchy returns last child" do
    task = TaskBuilder.new.with_default_title.build
    child = TaskBuilder.new.with_default_title.with_parent(task).save
    grandchild = TaskBuilder.new.with_default_title.with_parent(child).save

    assert_equal grandchild, task.next_step
  end

  test "next step of task with child hierarchy returns last uncompleted child" do
    task = TaskBuilder.new.with_default_title.build
    child = TaskBuilder.new.with_default_title.with_parent(task).save
    grandchild = TaskBuilder.new.with_default_title.with_parent(child).completed.save

    assert_equal child, task.next_step
  end

  test "last_uncompleted_child finds last child which is uncompleted" do
    task = TaskBuilder.new.with_default_title.build
    first_child = TaskBuilder.new.with_default_title.with_parent(task).save
    second_child = TaskBuilder.new.with_default_title.with_parent(task).completed.save

    assert_equal first_child, task.last_uncompleted_child
  end
end
