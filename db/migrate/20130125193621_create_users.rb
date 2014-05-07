class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :userid
      t.string :username
      t.text :token

      t.timestamps
    end
  end
end
