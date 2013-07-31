class TasksController < ApplicationController
  def new
  end

  def create
    @task = Task.new(task_params)

    @task.save
    redirect_to action: :new, :notice => "New task created"
  end

  def index
    @tasks = Task.all
  end

  def random
    tasks = Task.find(:all, :conditions => {:completed => false})
    puts tasks.length
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
end
