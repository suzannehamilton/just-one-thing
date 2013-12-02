class Task < ActiveRecord::Base
  belongs_to :parent, class_name: 'Task'
  has_many :children, class_name: 'Task', foreign_key: 'parent_id'

  belongs_to :user, class_name: 'User'

  validates :title, presence: true
  validates :user, presence: true

  scope :without_parent, -> { where(parent_id: nil) }
  scope :uncompleted, -> { where(completed: false) }

  def next_step
    next_child = last_uncompleted_child
    unless next_child.nil? then
      return next_child.next_step
    end
    return self
  end

  def last_uncompleted_child
    children.reverse_each.find { |child| child.completed == false }
  end
end
