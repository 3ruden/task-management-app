class CreateReads < ActiveRecord::Migration[5.2]
  def change
    create_table :reads do |t|
      t.references :task, foreign_key: true, index: true, null: false
      t.references :user, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
