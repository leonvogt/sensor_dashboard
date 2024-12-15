class CreateAPIErrors < ActiveRecord::Migration[7.0]
  def change
    create_table :api_errors do |t|
      t.text :error_message
      t.belongs_to :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
