class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :age
      t.string :tel
      t.string :email
      t.string :password_digest

      t.timestamps
      t.integer :lock_version, :default => 0
    end
  end
end
