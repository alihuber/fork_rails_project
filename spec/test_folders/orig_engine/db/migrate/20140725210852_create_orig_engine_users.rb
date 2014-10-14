class CreateOrigEngineUsers < ActiveRecord::Migration
  def change
    create_table :orig_engine_users do |t|
      t.string :email
      t.string :password_digest
      t.string :auth_token
      t.string :password_reset_token
      t.datetime :password_reset_sent_at

      t.timestamps
    end

    add_index :orig_engine_users, :email, unique: true
    add_index :orig_engine_users, :auth_token, unique: true
    add_index :orig_engine_users, :password_reset_token, unique: true
  end
end

