class UpdateUsersForDevise < ActiveRecord::Migration[7.1]
  def change
    # Rename column `password_digest` to `encrypted_password`
    rename_column :users, :password_digest, :encrypted_password

    # Ensure that `encrypted_password` cannot be null
    change_column_null :users, :encrypted_password, false

    # Remove existing index on `username` if it exists
    if index_exists?(:users, :username)
      remove_index :users, :username
    end

    # Remove existing index on `email` if it exists
    if index_exists?(:users, :email)
      remove_index :users, :email
    end

    # Add unique index on `email`
    add_index :users, :email, unique: true
  end
end
