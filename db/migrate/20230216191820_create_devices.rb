class CreateDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :devices do |t|
      t.string :name, null: false
      t.string :description
      t.string :access_token

      t.belongs_to :user, null: false, foreign_key: true

      t.index :access_token, unique: true
      t.timestamps
    end
  end
end
