class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :linkedin
      t.string :email

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
