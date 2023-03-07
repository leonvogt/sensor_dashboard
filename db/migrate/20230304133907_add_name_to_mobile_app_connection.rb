class AddNameToMobileAppConnection < ActiveRecord::Migration[7.0]
  def change
    add_column :mobile_app_connections, :name, :string
  end
end
