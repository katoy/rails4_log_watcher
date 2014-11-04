class CreateOperationallogs < ActiveRecord::Migration
  def change
    create_table :operationallogs do |t|
      t.string   :status
      t.string   :message
      t.timestamps
      t.integer :lock_version, :default => 0
    end
  end
end
