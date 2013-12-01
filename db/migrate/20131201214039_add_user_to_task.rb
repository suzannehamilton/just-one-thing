class AddUserToTask < ActiveRecord::Migration
  def self.up
    add_reference :tasks, :user, index: true

    if Task.count != 0
      dummy_user = User.create!({:email => "foo@bar.com", :password => "password", :password_confirmation => "password"})
      dummy_user.save
      dummy_user.reload

      puts dummy_user.id

      Task.all.each do |task|
        task.user_id = dummy_user.id
        task.save!
      end
    end

    change_column_null :tasks, :user_id, false
  end

  def self.down
    User.where(:email => "foo@bar.com").destroy_all
    remove_column :tasks, :user_id
  end
end
