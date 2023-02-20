class CreateSensors < ActiveRecord::Migration[7.0]
  def change
    create_table :sensors do |t|
      t.string :sensor_type, null: false
      t.string :chart_type, null: false

      t.belongs_to :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
