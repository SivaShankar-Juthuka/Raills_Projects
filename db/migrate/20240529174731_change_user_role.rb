class ChangeUserRole < ActiveRecord::Migration[7.1]
  def up
    User.where(role: 'noob').update_all(role: 'user')
  end

  def down
    User.where(role: 'user').update_all(role: 'noob')
  end
end
