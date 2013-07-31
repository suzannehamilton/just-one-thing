class Task < ActiveRecord::Base
  belongs_to :parent, class_name: 'Task'
  has_many :children, class_name: 'Task', foreign_key: 'parent_id'
end
