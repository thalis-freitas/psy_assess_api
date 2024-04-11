class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :cpf
      t.string :email, index: { unique: true }
      t.string :password_digest
      t.date :birth_date
      t.integer :role, default: 0

      t.timestamps
    end
  end
end
