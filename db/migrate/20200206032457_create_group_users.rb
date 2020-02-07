class CreateGroupUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :group_users do |t|
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :owner, default: false, null: false

      t.timestamps
    end

    add_index :group_users, [:user_id, :group_id], unique: true
  end
end
