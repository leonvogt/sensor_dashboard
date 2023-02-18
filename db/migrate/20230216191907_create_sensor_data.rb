class CreateSensorData < ActiveRecord::Migration[7.0]
  def change
    create_table :sensor_data do |t|
      t.belongs_to :sensor, null: false, foreign_key: true
      t.decimal :value, precision: 10, scale: 2, null: false
      t.string :value_type, null: false

      t.timestamps
    end
  end
end
