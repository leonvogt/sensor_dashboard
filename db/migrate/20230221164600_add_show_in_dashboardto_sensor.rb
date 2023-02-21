class AddShowInDashboardtoSensor < ActiveRecord::Migration[7.0]
  def change
    add_column :sensors, :show_in_dashboard, :boolean, default: true
  end
end
