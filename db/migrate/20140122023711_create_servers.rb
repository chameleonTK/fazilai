class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name
      t.string :domain
      t.string :user
      t.string :password

      t.timestamps
    end
  end
end
