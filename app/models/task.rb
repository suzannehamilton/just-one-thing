class Task < ActiveRecord::Base
  belongs_to :parent, class_name: 'Task'
  has_many :children, class_name: 'Task', foreign_key: 'parent_id'

  validates :title, presence: true

  scope :without_parent, -> { where(parent_id: nil) }
  scope :uncompleted, -> { where(completed: false) }

  def next_step
    if children.size > 0 then
      return children.last
    end
    return self
  end
end
