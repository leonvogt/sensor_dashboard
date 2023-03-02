class CreateAlarmRules < ActiveRecord::Migration[7.0]
  def change
    create_table :alarm_rules do |t|
      t.belongs_to :sensor, null: false, foreign_key: true
      t.string :rule_type
      t.decimal :value

      t.timestamps
    end
  end
end
