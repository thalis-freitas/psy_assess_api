class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :instrument, null: false, foreign_key: true
      t.string :text

      t.timestamps
    end
  end
end
