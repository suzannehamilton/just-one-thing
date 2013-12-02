class TaskBuilder
  def initialize
    @task = Task.new

    user = User.where(:email=>"foo@bar.com").first
    @task.user = user
  end

  def with_title(title)
    @task.title = title
    self
  end

  def with_default_title
    with_title("default title")
  end

  def with_parent(parent)
    @task.parent = parent
    self
  end

  def completed
    @task.completed = true
    self
  end

  def build
    @task
  end

  def save
    @task.save
    @task
  end
end
