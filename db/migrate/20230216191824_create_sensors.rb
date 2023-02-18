class CreateSensors < ActiveRecord::Migration[7.0]
  def change
    create_table :sensors do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.string :sensor_type, null: false
      t.string :access_token

      t.index :access_token, unique: true

      t.timestamps
    end
  end
end
