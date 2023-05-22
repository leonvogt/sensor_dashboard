class AddUserSignInToken < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :temporary_sign_in_token, :string
    add_column :users, :temporary_sign_in_token_created_at, :datetime
  end
end
