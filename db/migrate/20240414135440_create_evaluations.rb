class CreateEvaluations < ActiveRecord::Migration[7.1]
  def change
    create_table :evaluations do |t|
      t.references :evaluated, null: false, foreign_key: { to_table: :users }
      t.references :instrument, null: false, foreign_key: true
      t.integer :status, default: 0
      t.integer :score
      t.string :token

      t.timestamps
    end
  end
end
