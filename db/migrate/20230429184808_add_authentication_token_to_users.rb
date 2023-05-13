class AddAuthenticationTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :authentication_token, :string

    # Generate tokens for existing users
    User.find_each.map(&:regenerate_authentication_token)

    # Add uniqueness constraint to the token column
    add_index :users, :authentication_token, unique: true
  end
end
