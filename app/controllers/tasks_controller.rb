class TasksController < ApplicationController
  def new
  end

  def create
    @task = Task.new(task_params)
    @task.save
    redirect_to action: :new, :notice => "New task created"
  end

  def create_child
    @parent = Task.find(params[:id])
    @child = Task.new(child_task_params)
    @child.parent_id = @parent.id

    @child.save

    redirect_to action: :new, :notice => "New child task created"
  end

  def index
    @tasks = Task.all.select {|t| t.parent_id == nil }
  end

  def random
    tasks = Task.all(:conditions => {:completed => false})
    @task = tasks.sample
  end

  def complete
    @task = Task.find(params[:id])
    @task.update_attributes(:completed => true)

    redirect_to controller: :welcome, :notice => "Task completed"
  end

  private
    def task_params
      params.require(:task).permit(:title)
    end

    def child_task_params
      params.require(:child_task).permit(:title)
    end
end
