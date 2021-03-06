class TasksController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def new
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user
    @task.save
    redirect_to action: :new, :notice => "New task created"
  end

  def create_child
    @parent = Task.find(params[:id])
    @child = Task.new(child_task_params)
    @child.user = current_user
    @child.parent_id = @parent.id

    @child.save

    redirect_to action: :new, :notice => "New child task created"
  end

  def all
    @tasks = Task.without_parent.select {|t| t.user_id == current_user.id}
  end

  def random
    top_level_tasks = Task.uncompleted.without_parent.select {|t| t.user_id == current_user.id}

    if top_level_tasks.empty?
      redirect_to action: :success, :notice => "All tasks completed"
    else
      @chosen_task = top_level_tasks.sample
      @task = @chosen_task.next_step
    end
  end

  def complete
    @task = Task.find(params[:id])
    @task.update_attributes(:completed => true)

    redirect_to action: :index, :notice => "Task completed"
  end

  def success
  end

  private
    def task_params
      params.require(:task).permit(:title)
    end

    def child_task_params
      params.require(:child_task).permit(:title)
    end
end
