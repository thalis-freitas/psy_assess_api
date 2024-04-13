class CreateOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      t.references :question, null: false, foreign_key: true
      t.string :text
      t.integer :score_value

      t.timestamps
    end
  end
end
