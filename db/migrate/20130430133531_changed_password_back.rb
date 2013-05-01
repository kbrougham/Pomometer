class ChangedPasswordBack < ActiveRecord::Migration
  def up
  	rename_column :admins, :password_digest, :password
  end

  def down
  end
end
