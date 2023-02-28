class CreateMobileAppConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :mobile_app_connections do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :platform
      t.string :notification_token
      t.string :app_version
      t.string :unique_mobile_id

      t.index :notification_token, unique: true
      t.timestamps
    end
  end
end
