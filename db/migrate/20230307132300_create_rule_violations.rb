class CreateRuleViolations < ActiveRecord::Migration[7.0]
  def change
    create_table :rule_violations do |t|
      t.belongs_to :alarm_rule, null: false, foreign_key: true
      t.integer :status
      t.string :violation_text
      t.datetime :closed_at

      t.timestamps
    end
  end
end
