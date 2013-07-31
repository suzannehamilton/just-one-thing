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
    @task = Task.offset(rand(Task.count)).first
  end

  private
    def task_params
      params.require(:task).permit(:title)
    end
end
