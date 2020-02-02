class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.string :name, null: false
      t.index :name, unique: true

      t.timestamps
    end
  end
end
