class RenamePasswordToPasswordDigest < ActiveRecord::Migration
  def up
  		rename_column :admins, :password, :password_digest
  end

  def down
  end
end
