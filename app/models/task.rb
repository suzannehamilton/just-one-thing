class Task < ActiveRecord::Base
  belongs_to :parent, class_name: 'Task'
  has_many :children, class_name: 'Task', foreign_key: 'parent_id'

  validates :title, presence: true

  # scope :without_children, includes(:children).where(:children => nil)
  scope :without_children, joins("left join tasks as children on children.parent_id = tasks.id").where("children.parent_id is null")
end
