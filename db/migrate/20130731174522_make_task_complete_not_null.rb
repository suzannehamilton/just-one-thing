class MakeTaskCompleteNotNull < ActiveRecord::Migration
  def up
    Task.where(:completed => nil).update_all(:completed => false)
    change_column_null :tasks, :completed, false
  end

  def down
    change_column_null :tasks, :completed, false
  end
end
