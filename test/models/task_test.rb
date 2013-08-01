require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "should not save task without title" do
    task = Task.new
    task.completed = false
    assert !task.save, "Saved the task without a title"
  end
end
